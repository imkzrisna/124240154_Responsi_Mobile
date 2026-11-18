import 'package:flutter/material.dart';

import '../database/hive_service.dart';
import '../models/game.dart';
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final int gameId;

  const DetailScreen({super.key, required this.gameId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService _apiService = ApiService();
  final HiveService _hiveService = HiveService();

  Game? _game;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isOwned = false;

  @override
  void initState() {
    super.initState();
    // Cek ke Hive apakah game ini sudah dimiliki.
    _isOwned = _hiveService.isOwned(widget.gameId);
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final game = await _apiService.fetchGameDetail(widget.gameId);
      if (!mounted) return;
      setState(() {
        _game = game;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // Menyimpan game ke Hive saat tombol Get ditekan.
  Future<void> _addToLibrary(Game game) async {
    try {
      await _hiveService.add(game);
      if (!mounted) return;
      setState(() {
        _isOwned = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${game.name} ditambahkan ke library')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan ke library')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null || _game == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'Data tidak tersedia',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDetail,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final game = _game!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Hero image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
            game.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // 2. Genre dan platform
        Row(
          children: [
            _buildTag(game.genre),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                game.platform,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 3. Nama game
        Text(
          game.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // 4. Tanggal rilis, publisher, developer
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildInfo('Release Date', game.releaseDate)),
            Expanded(child: _buildInfo('Publisher', game.publisher)),
            Expanded(child: _buildInfo('Developer', game.developer)),
          ],
        ),
        const SizedBox(height: 16),

        // 5. Tombol Get / In Library
        _buildGetButton(game),
        const SizedBox(height: 20),

        // 6. Screenshots
        const Text(
          'Screenshots',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildScreenshots(game.screenshots),
        const SizedBox(height: 20),

        // 7. Deskripsi
        const Text(
          'Overview',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          game.description.isEmpty ? 'Tidak ada deskripsi.' : game.description,
          style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // Tampilan tombol berbeda tergantung status kepemilikan.
  Widget _buildGetButton(Game game) {
    if (_isOwned) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.check, size: 16),
          label: const Text('In Library'),
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: const Color(0xFF3A3A3C),
            disabledForegroundColor: Colors.white,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _addToLibrary(game),
        icon: const Icon(Icons.add, size: 16),
        label: const Text('Get'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildScreenshots(List<String> screenshots) {
    if (screenshots.isEmpty) {
      return const Text(
        'Tidak ada screenshot.',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      );
    }

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: screenshots.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
              screenshots[index],
              width: 150,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 150,
                  child: Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

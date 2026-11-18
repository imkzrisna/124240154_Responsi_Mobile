import 'package:flutter/material.dart';

import '../database/hive_service.dart';
import '../services/pref_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PrefService _prefService = PrefService();
  final HiveService _hiveService = HiveService();

  String _email = '';
  int _gameCount = 0;

  @override
  void initState() {
    super.initState();
    // Jumlah game dari Hive (sinkron).
    _gameCount = _hiveService.count();
    // Email dari SharedPreferences (async).
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final email = await _prefService.getEmail();
    if (!mounted) return;
    setState(() {
      _email = email;
    });
  }

  Future<void> _logout() async {
    try {
      await _prefService.logout();
      if (!mounted) return;

      // Hapus semua halaman di tumpukan, lalu buka Login.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Gagal logout')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF3A3A3C),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 32),
            _buildRow('Email:', _email),
            const SizedBox(height: 12),
            _buildRow('Games Dimiliki:', '$_gameCount'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

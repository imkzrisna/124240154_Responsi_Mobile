import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menyimpan semua halaman, hanya satu yang terlihat.
      // Home dibiarkan hidup agar data API tidak diunduh ulang.
      // Library dan Profil dibuat baru setiap dipilih supaya
      // datanya selalu terbaru dari Hive.
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          _currentIndex == 1 ? const LibraryScreen() : const SizedBox.shrink(),
          _currentIndex == 2 ? const ProfileScreen() : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

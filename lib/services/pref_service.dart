import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static const String _keyEmail = 'email';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  // Menyimpan data login setelah pengguna menekan tombol Login.
  Future<void> saveLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // Apakah pengguna sudah login?
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Membaca email yang tersimpan (dipakai di Profile Page).
  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '';
  }

  // Menghapus data login (dipakai saat Logout).
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyIsLoggedIn);
  }
}

cat > README.md <<'EOF'
# Hydra Games

Aplikasi Flutter untuk browsing dan mengoleksi game, dibuat sebagai latihan
(124240154 - Responsi Mobile).

## Akun Login

Gunakan email dan password berikut untuk masuk ke aplikasi:

| Email | Password |
|---|---|
| `kariz154@gmail.com` | `mobilecihuy` |

Email dan password selain di atas akan ditolak dengan pesan
"Email atau password salah".

## Fitur

- **Login:** validasi input, sesi disimpan dengan SharedPreferences.
- **Beranda:** daftar game (thumbnail, nama, genre, platform) dari API.
- **Detail:** hero image, info rilis, screenshot, deskripsi, dan tombol Get.
- **Library:** daftar game yang dimiliki, disimpan dengan Hive, bisa dihapus.
- **Profil:** email pengguna, jumlah game di library, dan logout.

## Teknologi

- Flutter dan Dart
- Package `http` untuk REST API
- SharedPreferences untuk data sesi
- Hive dan Hive Flutter untuk database lokal

## Sumber Data

- Daftar game: https://www.freetogame.com/api/games
- Detail game: https://www.freetogame.com/api/game?id={game_id}

## Cara Menjalankan

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

## Menjalankan Tes

```bash
flutter analyze
flutter test
```
EOF

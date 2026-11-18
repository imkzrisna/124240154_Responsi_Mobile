import 'package:flutter_test/flutter_test.dart';
import 'package:hydra_games/services/pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    // Memakai penyimpanan palsu di memori untuk tes.
    SharedPreferences.setMockInitialValues({});
  });

  test('saveLogin menyimpan email dan status login', () async {
    final service = PrefService();

    expect(await service.isLoggedIn(), false);

    await service.saveLogin('umar@gmail.com');

    expect(await service.isLoggedIn(), true);
    expect(await service.getEmail(), 'umar@gmail.com');
  });

  test('logout menghapus data login', () async {
    final service = PrefService();
    await service.saveLogin('umar@gmail.com');

    await service.logout();

    expect(await service.isLoggedIn(), false);
    expect(await service.getEmail(), '');
  });
}

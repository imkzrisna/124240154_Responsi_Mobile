import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra_games/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buatApp() {
  return const MaterialApp(home: LoginScreen());
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('kolom kosong menampilkan pesan wajib diisi', (tester) async {
    await tester.pumpWidget(buatApp());

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });

  testWidgets('format email salah ditolak', (tester) async {
    await tester.pumpWidget(buatApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'abc');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Format email tidak valid'), findsOneWidget);
  });

  testWidgets('password kurang dari 6 karakter ditolak', (tester) async {
    await tester.pumpWidget(buatApp());

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'kariz154@gmail.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Password minimal 6 karakter'), findsOneWidget);
  });

  testWidgets('kredensial salah menampilkan SnackBar', (tester) async {
    await tester.pumpWidget(buatApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'orang@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'passwordsalah');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email atau password salah'), findsOneWidget);
  });
}

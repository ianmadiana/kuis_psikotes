import 'package:flutter/material.dart';

import 'package:kuis_psikotes/pages/home_page.dart';

// warna untuk tema diatur secara global ditandai dengan nama variabel k...
var kColorSchemeBlue = ColorScheme.fromSeed(seedColor: Colors.blue);
var kDarkColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF3C0753));

// data objek untuk mengatur tema gelap
var myThemeDark = ThemeData.dark().copyWith(
  colorScheme: kDarkColorScheme,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
      backgroundColor: kDarkColorScheme.onPrimaryContainer,
      foregroundColor: kDarkColorScheme.onPrimary),
);

// data objek untuk mengatur tema terang dengan aksen blue
var myThemeBlue = ThemeData.light().copyWith(
    colorScheme: kDarkColorScheme,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
        backgroundColor: kDarkColorScheme.onPrimaryContainer,
        foregroundColor: kDarkColorScheme.onPrimary),
    textTheme: const TextTheme()
        .copyWith(titleMedium: TextStyle(color: kColorSchemeBlue.secondary)));

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // default tema yang digunakan
      theme: myThemeBlue,

      // mode untuk tema yang digunakan
      themeMode: ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kuis App'),
        ),
        body: const HomePage(),
      ),
    );
  }
}

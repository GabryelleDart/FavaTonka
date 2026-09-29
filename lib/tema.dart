import 'package:flutter/material.dart';

class Cores {
  static const Color vinho = Color(0xFF4A1D3F);
  static const Color dourado = Color(0xFFC8A15B);
  static const Color creme = Color(0xFFFBF6EE);
  static const Color tinta = Color(0xFF2B1B27);
}

const String fonteTitulo = 'serif';

ThemeData criarTema() {
  final esquema = ColorScheme.fromSeed(
    seedColor: Cores.vinho,
    primary: Cores.vinho,
    secondary: Cores.dourado,
    surface: Cores.creme,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: Cores.creme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Cores.creme,
      foregroundColor: Cores.vinho,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
  );
}

void avisar(BuildContext context, String mensagem) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
  );
}

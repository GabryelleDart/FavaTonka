import 'package:flutter/material.dart';

/// Fontes (declaradas no pubspec.yaml, arquivos em recursos/fontes).
const String fonteTitulo = 'Lora';
const String fonteCorpo = 'Poppins';

/// Dourado fixo, usado nos desenhos que não mudam com o tema.
class Cores {
  static const Color dourado = Color(0xFFC8A15B);
}

/// Paleta própria do app. Tema claro: vinho, dourado e creme.
/// Tema escuro: preto com tons de lilás.
@immutable
class Paleta extends ThemeExtension<Paleta> {
  final Color fundo;
  final Color superficie;
  final Color superficieAlta;
  final Color titulo;
  final Color destaque;
  final Color texto;
  final Color textoSuave;
  final Color borda;

  const Paleta({
    required this.fundo,
    required this.superficie,
    required this.superficieAlta,
    required this.titulo,
    required this.destaque,
    required this.texto,
    required this.textoSuave,
    required this.borda,
  });

  static const Paleta claro = Paleta(
    fundo: Color(0xFFFBF6EE),
    superficie: Color(0xFFFFFFFF),
    superficieAlta: Color(0xFFF3EADB),
    titulo: Color(0xFF4A1D3F),
    destaque: Color(0xFFC8A15B),
    texto: Color(0xFF2B1B27),
    textoSuave: Color(0xFF7A6B75),
    borda: Color(0xFFEADFCB),
  );

  static const Paleta escuro = Paleta(
    fundo: Color(0xFF0A090E),
    superficie: Color(0xFF15111D),
    superficieAlta: Color(0xFF211A33),
    titulo: Color(0xFFD2C1F5),
    destaque: Color(0xFFB59AF0),
    texto: Color(0xFFECE6F7),
    textoSuave: Color(0xFF9A90AE),
    borda: Color(0xFF2A2240),
  );

  @override
  Paleta copyWith({
    Color? fundo,
    Color? superficie,
    Color? superficieAlta,
    Color? titulo,
    Color? destaque,
    Color? texto,
    Color? textoSuave,
    Color? borda,
  }) {
    return Paleta(
      fundo: fundo ?? this.fundo,
      superficie: superficie ?? this.superficie,
      superficieAlta: superficieAlta ?? this.superficieAlta,
      titulo: titulo ?? this.titulo,
      destaque: destaque ?? this.destaque,
      texto: texto ?? this.texto,
      textoSuave: textoSuave ?? this.textoSuave,
      borda: borda ?? this.borda,
    );
  }

  @override
  Paleta lerp(ThemeExtension<Paleta>? other, double t) {
    if (other is! Paleta) return this;
    return Paleta(
      fundo: Color.lerp(fundo, other.fundo, t)!,
      superficie: Color.lerp(superficie, other.superficie, t)!,
      superficieAlta: Color.lerp(superficieAlta, other.superficieAlta, t)!,
      titulo: Color.lerp(titulo, other.titulo, t)!,
      destaque: Color.lerp(destaque, other.destaque, t)!,
      texto: Color.lerp(texto, other.texto, t)!,
      textoSuave: Color.lerp(textoSuave, other.textoSuave, t)!,
      borda: Color.lerp(borda, other.borda, t)!,
    );
  }
}

extension PaletaNoContexto on BuildContext {
  Paleta get paleta => Theme.of(this).extension<Paleta>()!;
}

ThemeData _montarTema(Paleta p, Brightness brilho) {
  final escuro = brilho == Brightness.dark;

  final esquema = escuro
      ? ColorScheme.dark(
          primary: p.titulo,
          onPrimary: const Color(0xFF1A1030),
          secondary: p.destaque,
          surface: p.fundo,
          onSurface: p.texto,
        )
      : ColorScheme.light(
          primary: p.titulo,
          onPrimary: Colors.white,
          secondary: p.destaque,
          surface: p.fundo,
          onSurface: p.texto,
        );

  return ThemeData(
    useMaterial3: true,
    brightness: brilho,
    colorScheme: esquema,
    fontFamily: fonteCorpo,
    scaffoldBackgroundColor: p.fundo,
    canvasColor: p.fundo,
    extensions: [p],
    appBarTheme: AppBarTheme(
      backgroundColor: p.fundo,
      foregroundColor: p.titulo,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: DividerThemeData(color: p.borda, space: 1, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.titulo,
      contentTextStyle: TextStyle(
        color: escuro ? const Color(0xFF1A1030) : Colors.white,
        fontFamily: fonteCorpo,
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

ThemeData criarTemaClaro() => _montarTema(Paleta.claro, Brightness.light);
ThemeData criarTemaEscuro() => _montarTema(Paleta.escuro, Brightness.dark);

void avisar(BuildContext context, String mensagem) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text(mensagem)));
}

/// Largura máxima do conteúdo em telas grandes (desktop/web).
const double larguraMaxima = 1240;

bool telaLarga(BuildContext context) => MediaQuery.sizeOf(context).width >= 900;

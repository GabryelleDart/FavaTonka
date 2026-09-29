import 'package:flutter/material.dart';

class Nota {
  final String chave;
  final String nome;
  final String emoji;
  final Color cor1;
  final Color cor2;

  const Nota({
    required this.chave,
    required this.nome,
    required this.emoji,
    required this.cor1,
    required this.cor2,
  });

  /// Foto opcional da nota. Se o arquivo não existir, o app usa o
  /// círculo com gradiente e emoji.
  String get caminhoImagem => 'recursos/imagens/notas/$chave.jpg';

  factory Nota.fromJson(String chave, Map<String, dynamic> json) {
    return Nota(
      chave: chave,
      nome: json['nome'] as String,
      emoji: json['emoji'] as String,
      cor1: _cor(json['cor1'] as String),
      cor2: _cor(json['cor2'] as String),
    );
  }

  factory Nota.desconhecida(String chave) {
    final texto = chave.replaceAll('_', ' ');
    final nome = texto.isEmpty
        ? chave
        : '${texto[0].toUpperCase()}${texto.substring(1)}';
    return Nota(
      chave: chave,
      nome: nome,
      emoji: '✨',
      cor1: const Color(0xFFF3E7D3),
      cor2: const Color(0xFFC8A15B),
    );
  }

  static Color _cor(String hex) {
    final limpo = hex.replaceAll('#', '');
    return Color(int.parse('FF$limpo', radix: 16));
  }
}

import 'package:flutter/material.dart';

/// Nota olfativa. Vem pronta do serviço "perfumes" (nome, emoji e cores).
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

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      chave: json['chave'] as String,
      nome: json['nome'] as String,
      emoji: json['emoji'] as String,
      cor1: _cor(json['cor1'] as String),
      cor2: _cor(json['cor2'] as String),
    );
  }

  static Color _cor(String hex) {
    final limpo = hex.replaceAll('#', '');
    return Color(int.parse('FF$limpo', radix: 16));
  }
}

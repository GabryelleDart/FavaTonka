import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/catalogo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GerenciadorEstado()..carregarDados(),
      child: const FavaTonka(),
    ),
  );
}

class FavaTonka extends StatelessWidget {
  const FavaTonka({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FavaTonka',
      debugShowCheckedModeBanner: false,
      theme: criarTema(),
      home: const TelaCatalogo(),
    );
  }
}

import 'dart:ui' show PointerDeviceKind;
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
    final modo = context.select<GerenciadorEstado, ThemeMode>((e) => e.modoTema);

    return MaterialApp(
      title: 'FavaTonka',
      debugShowCheckedModeBanner: false,
      theme: criarTemaClaro(),
      darkTheme: criarTemaEscuro(),
      themeMode: modo,
      // Permite arrastar listas horizontais com o mouse no desktop e na web.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      home: const TelaCatalogo(),
    );
  }
}

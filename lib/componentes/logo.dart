import 'package:favatonka/tema.dart';
import 'package:flutter/material.dart';

/// Logotipo "FavaTonka": Fava em serifa romana, Tonka em itálico.
class Logo extends StatelessWidget {
  final double tamanho;

  const Logo({super.key, this.tamanho = 26});

  @override
  Widget build(BuildContext context) {
    final p = context.paleta;

    return Semantics(
      label: 'FavaTonka',
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Fava',
                style: TextStyle(
                  fontFamily: fonteTitulo,
                  fontWeight: FontWeight.w500,
                  color: p.titulo,
                ),
              ),
              TextSpan(
                text: 'Tonka',
                style: TextStyle(
                  fontFamily: fonteTitulo,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: p.destaque,
                ),
              ),
            ],
          ),
          style: TextStyle(fontSize: tamanho, letterSpacing: 0.4, height: 1.1),
          maxLines: 1,
        ),
      ),
    );
  }
}

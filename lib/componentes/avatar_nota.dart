import 'package:favatonka/modelos/nota.dart';
import 'package:favatonka/tema.dart';
import 'package:flutter/material.dart';

/// Círculo com o emoji da nota sobre um gradiente com as cores dela.
class AvatarNota extends StatelessWidget {
  final Nota nota;
  final double tamanho;
  final bool mostrarNome;
  final VoidCallback? onTap;

  const AvatarNota({
    super.key,
    required this.nota,
    this.tamanho = 64,
    this.mostrarNome = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final anel = tamanho * 0.055;

    final circulo = Container(
      width: tamanho,
      height: tamanho,
      padding: EdgeInsets.all(anel),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Cores.dourado, nota.cor2],
        ),
        boxShadow: [
          BoxShadow(
            color: nota.cor2.withValues(alpha: 0.35),
            blurRadius: tamanho * 0.16,
            offset: Offset(0, tamanho * 0.05),
          ),
        ],
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.4),
            radius: 1.1,
            colors: [nota.cor1, nota.cor2],
          ),
        ),
        child: Text(nota.emoji, style: TextStyle(fontSize: tamanho * 0.45)),
      ),
    );

    final conteudo = mostrarNome
        ? SizedBox(
            width: tamanho + 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                circulo,
                const SizedBox(height: 6),
                Text(
                  nota.nome,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.15,
                    color: Cores.tinta,
                  ),
                ),
              ],
            ),
          )
        : circulo;

    if (onTap == null) return conteudo;
    return GestureDetector(onTap: onTap, child: conteudo);
  }
}
import 'package:favatonka/componentes/avatar_nota.dart';
import 'package:favatonka/modelos/nota.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:flutter/material.dart';

class PiramideOlfativa extends StatelessWidget {
  final Perfume perfume;
  final void Function(Nota nota) onNotaTap;

  const PiramideOlfativa({
    super.key,
    required this.perfume,
    required this.onNotaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _nivel(context, 'TOPO', 'primeiros minutos', perfume.topo),
        _nivel(context, 'CORAÇÃO', 'algumas horas', perfume.coracao),
        _nivel(context, 'FUNDO', 'o que fica na pele', perfume.fundo),
      ],
    );
  }

  Widget _nivel(
    BuildContext context,
    String titulo,
    String legenda,
    List<Nota> notas,
  ) {
    if (notas.isEmpty) return const SizedBox.shrink();
    final p = context.paleta;

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  fontSize: 11.5,
                  color: p.titulo,
                ),
              ),
              const SizedBox(width: 10),
              Text(legenda, style: TextStyle(fontSize: 12, color: p.textoSuave)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            runSpacing: 14,
            children: [
              for (final nota in notas)
                AvatarNota(
                  nota: nota,
                  tamanho: 64,
                  mostrarNome: true,
                  onTap: () => onNotaTap(nota),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

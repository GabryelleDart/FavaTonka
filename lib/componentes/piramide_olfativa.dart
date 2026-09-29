import 'package:favatonka/componentes/avatar_nota.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/modelos/nota.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    List<String> chaves,
  ) {
    if (chaves.isEmpty) return const SizedBox.shrink();
    final estado = context.read<GerenciadorEstado>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.6,
                  fontSize: 12,
                  color: Cores.vinho,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                legenda,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: chaves.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final nota = estado.nota(chaves[i]);
                return AvatarNota(
                  nota: nota,
                  tamanho: 68,
                  mostrarNome: true,
                  onTap: () => onNotaTap(nota),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

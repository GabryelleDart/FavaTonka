import 'package:favatonka/componentes/avatar_nota.dart';
import 'package:favatonka/componentes/foto_perfume.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/detalhes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartaoPerfume extends StatelessWidget {
  final Perfume perfume;
  final String prefixoHero;

  const CartaoPerfume({
    super.key,
    required this.perfume,
    this.prefixoHero = 'catalogo',
  });

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    final favorito = estado.ehFavorito(perfume.id);
    final chaves = (perfume.coracao.isNotEmpty ? perfume.coracao : perfume.todasNotas)
        .take(4)
        .toList();

    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: Cores.vinho.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => abrirDetalhes(context, perfume.id, '$prefixoHero-${perfume.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: '$prefixoHero-${perfume.id}',
                    child: FotoPerfume(perfume: perfume),
                  ),
                  if (favorito)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite, size: 18, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perfume.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: fonteTitulo,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Cores.vinho,
                    ),
                  ),
                  if (perfume.marca.isNotEmpty)
                    Text(
                      perfume.marca,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 30,
                    child: chaves.isEmpty
                        ? const Text(
                            'notas em breve',
                            style: TextStyle(fontSize: 11, color: Colors.black38),
                          )
                        : Row(
                            children: [
                              for (final k in chaves)
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: AvatarNota(
                                    nota: estado.nota(k),
                                    tamanho: 28,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

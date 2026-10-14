import 'package:favatonka/componentes/avatar_nota.dart';
import 'package:favatonka/componentes/foto_perfume.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/detalhes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Cartão no estilo vitrine: foto grande, texto enxuto embaixo.
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
    final p = context.paleta;
    final favorito = estado.ehFavorito(perfume.id);
    final todas = perfume.coracao.isNotEmpty ? perfume.coracao : perfume.todasNotas;
    final chaves = todas.take(4).toList();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => abrirDetalhes(context, perfume.id, '$prefixoHero-${perfume.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  color: p.superficie,
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
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.favorite, size: 16, color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              perfume.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: fonteTitulo,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: p.titulo,
              ),
            ),
            if (perfume.marca.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  perfume.marca,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: p.textoSuave),
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              height: 26,
              child: chaves.isEmpty
                  ? Text(
                      'notas em breve',
                      style: TextStyle(fontSize: 11, color: p.textoSuave),
                    )
                  : LayoutBuilder(
                      builder: (context, caixa) {
                        // Cada círculo ocupa ~30px; sobra espaço para o "+N".
                        final cabem =
                            ((caixa.maxWidth - 30) / 30).floor().clamp(1, 4).toInt();
                        final mostrar = chaves.take(cabem).toList();
                        final restantes = perfume.todasNotas.length - mostrar.length;

                        return Row(
                          children: [
                            for (final k in mostrar)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: AvatarNota(nota: estado.nota(k), tamanho: 26),
                              ),
                            if (restantes > 0)
                              Text(
                                '+$restantes',
                                style: TextStyle(fontSize: 11.5, color: p.textoSuave),
                              ),
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

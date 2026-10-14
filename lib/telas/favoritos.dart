import 'package:favatonka/componentes/foto_perfume.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/detalhes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaFavoritos extends StatelessWidget {
  const TelaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    final p = context.paleta;
    final lista = estado.favoritos;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus favoritos',
          style: TextStyle(fontFamily: fonteTitulo, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: lista.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border, size: 56, color: p.destaque),
                        const SizedBox(height: 12),
                        Text(
                          'Você ainda não favoritou nenhum perfume.\nToque no coração na tela de detalhes.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: p.textoSuave, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lista.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final perfume = lista[i];
                    return Material(
                      color: p.superficie,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: p.borda),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: SizedBox(
                          width: 64,
                          height: 64,
                          child: ClipOval(
                            child: Hero(
                              tag: 'favoritos-${perfume.id}',
                              child: FotoPerfume(perfume: perfume),
                            ),
                          ),
                        ),
                        title: Text(
                          perfume.nome,
                          style: TextStyle(
                            fontFamily: fonteTitulo,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: p.titulo,
                          ),
                        ),
                        subtitle: Text(
                          perfume.marca.isEmpty ? perfume.familias.join(' · ') : perfume.marca,
                          style: TextStyle(color: p.textoSuave),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            estado.alternarFavorito(perfume.id);
                            avisar(context, '${perfume.nome} removido dos favoritos');
                          },
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          tooltip: 'Remover dos favoritos',
                        ),
                        onTap: () =>
                            abrirDetalhes(context, perfume.id, 'favoritos-${perfume.id}'),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

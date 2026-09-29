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
    final lista = estado.favoritos;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus favoritos',
          style: TextStyle(fontFamily: fonteTitulo, fontWeight: FontWeight.bold),
        ),
      ),
      body: lista.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 56, color: Cores.dourado),
                    SizedBox(height: 12),
                    Text(
                      'Você ainda não favoritou nenhum perfume.\nToque no coração na tela de detalhes.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: lista.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final p = lista[i];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: SizedBox(
                      width: 64,
                      height: 64,
                      child: ClipOval(
                        child: Hero(
                          tag: 'favoritos-${p.id}',
                          child: FotoPerfume(perfume: p),
                        ),
                      ),
                    ),
                    title: Text(
                      p.nome,
                      style: const TextStyle(
                        fontFamily: fonteTitulo,
                        fontWeight: FontWeight.bold,
                        color: Cores.vinho,
                      ),
                    ),
                    subtitle: Text(p.marca.isEmpty ? p.familias.join(' · ') : p.marca),
                    trailing: IconButton(
                      onPressed: () {
                        estado.alternarFavorito(p.id);
                        avisar(context, '${p.nome} removido dos favoritos');
                      },
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      tooltip: 'Remover dos favoritos',
                    ),
                    onTap: () => abrirDetalhes(context, p.id, 'favoritos-${p.id}'),
                  ),
                );
              },
            ),
    );
  }
}

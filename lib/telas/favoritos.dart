// ignore_for_file: constant_identifier_names

import 'package:favatonka/api/servicos.dart';
import 'package:favatonka/componentes/foto_perfume.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/detalhes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const int TAMANHO_PAGINA_FAVORITOS = 8;

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});

  @override
  State<TelaFavoritos> createState() => _TelaFavoritosState();
}

class _TelaFavoritosState extends State<TelaFavoritos> {
  final ServicoFavoritos _servico = ServicoFavoritos();
  final ScrollController _rolagem = ScrollController();

  final List<Perfume> _lista = [];
  int _ultimoFavorito = 0; // marcador da paginação (id do último favorito recebido)
  bool _carregando = false;
  bool _temMais = true;
  bool _erro = false;

  @override
  void initState() {
    super.initState();
    _rolagem.addListener(() {
      if (_rolagem.hasClients && _rolagem.position.extentAfter < 300) {
        _carregarMais();
      }
    });
    _carregarMais();
  }

  @override
  void dispose() {
    _rolagem.dispose();
    super.dispose();
  }

  Future<void> _carregarMais() async {
    final usuario = context.read<GerenciadorEstado>().usuario;
    if (usuario == null || _carregando || !_temMais || _erro) return;

    setState(() => _carregando = true);

    try {
      final lote = await _servico.listar(
        usuario,
        ultimoFavorito: _ultimoFavorito,
        tamanho: TAMANHO_PAGINA_FAVORITOS,
      );
      if (!mounted) return;

      setState(() {
        _lista.addAll(lote);
        if (lote.isNotEmpty) _ultimoFavorito = lote.last.idFavorito ?? _ultimoFavorito;
        _temMais = lote.length == TAMANHO_PAGINA_FAVORITOS;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = true;
        _carregando = false;
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_rolagem.hasClients && _rolagem.position.maxScrollExtent <= 0) {
        _carregarMais();
      }
    });
  }

  Future<void> _remover(Perfume perfume) async {
    final estado = context.read<GerenciadorEstado>();
    final ok = await estado.alternarFavorito(perfume.id);
    if (!mounted) return;

    if (ok) {
      setState(() => _lista.removeWhere((p) => p.id == perfume.id));
      avisar(context, '${perfume.nome} removido dos favoritos');
    } else {
      avisar(context, 'Não foi possível remover dos favoritos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.paleta;
    final vazio = _lista.isEmpty && !_carregando && !_erro;

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
          child: vazio
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
              : ListView.builder(
                  controller: _rolagem,
                  padding: const EdgeInsets.all(16),
                  itemCount: _lista.length + 1,
                  itemBuilder: (context, i) {
                    if (i == _lista.length) return _rodape();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _item(_lista[i]),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _item(Perfume perfume) {
    final p = context.paleta;

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
          onPressed: () => _remover(perfume),
          icon: const Icon(Icons.favorite, color: Colors.red),
          tooltip: 'Remover dos favoritos',
        ),
        onTap: () => abrirDetalhes(context, perfume, 'favoritos-${perfume.id}'),
      ),
    );
  }

  Widget _rodape() {
    final p = context.paleta;

    if (_carregando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_erro) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(
              'Não foi possível carregar os favoritos.',
              style: TextStyle(color: p.textoSuave),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                setState(() => _erro = false);
                _carregarMais();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return const SizedBox(height: 24);
  }
}

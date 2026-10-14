import 'package:favatonka/autenticador.dart';
import 'package:favatonka/componentes/cartao_perfume.dart';
import 'package:favatonka/componentes/logo.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/favoritos.dart';
import 'package:favatonka/telas/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaCatalogo extends StatefulWidget {
  const TelaCatalogo({super.key});

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  final _controladorBusca = TextEditingController();
  String _busca = '';
  String? _familia;

  @override
  void dispose() {
    _controladorBusca.dispose();
    super.dispose();
  }

  void _abrirFavoritos(GerenciadorEstado estado) {
    if (!estado.logado) {
      avisar(context, 'Entre para ver seus favoritos');
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TelaLogin()));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TelaFavoritos()));
  }

  Future<void> _loginLogoff(GerenciadorEstado estado) async {
    if (estado.logado) {
      await Autenticador.logout();
      estado.logout();
      if (mounted) avisar(context, 'Você foi desconectado com sucesso');
    } else {
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TelaLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    final p = context.paleta;
    final larga = telaLarga(context);
    final escuro = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: larga ? 72 : 60,
        centerTitle: !larga,
        titleSpacing: larga ? 32 : null,
        title: Logo(tamanho: larga ? 32 : 27),
        actions: [
          IconButton(
            onPressed: () => estado.alternarTema(Theme.of(context).brightness),
            icon: Icon(escuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            tooltip: escuro ? 'Tema claro' : 'Tema escuro',
          ),
          IconButton(
            onPressed: () => _abrirFavoritos(estado),
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Favoritos',
          ),
          IconButton(
            onPressed: () => _loginLogoff(estado),
            icon: Icon(estado.logado ? Icons.logout : Icons.person_outline),
            tooltip: estado.logado ? 'Sair' : 'Entrar',
          ),
          SizedBox(width: larga ? 24 : 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: p.borda),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: larguraMaxima),
          child: _corpo(estado),
        ),
      ),
    );
  }

  Widget _corpo(GerenciadorEstado estado) {
    final p = context.paleta;

    if (estado.carregando && estado.perfumes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (estado.erro != null && estado.perfumes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(estado.erro!, style: TextStyle(color: p.texto)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: estado.carregarDados,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    final lista = estado.perfumesFiltrados(_busca, _familia);

    return LayoutBuilder(
      builder: (context, caixa) {
        final largura = caixa.maxWidth;
        final larga = largura >= 900;
        final margem = larga ? 32.0 : 16.0;
        final espaco = larga ? 20.0 : 12.0;

        // Quantas colunas cabem com cartões de, no mínimo, ~175px.
        final colunas = ((largura - 2 * margem + espaco) / (175 + espaco))
            .floor()
            .clamp(2, 6)
            .toInt();
        final larguraCartao = (largura - 2 * margem - (colunas - 1) * espaco) / colunas;
        final escala =
            (MediaQuery.textScalerOf(context).scale(14) / 14).clamp(1.0, 1.6).toDouble();
        final alturaCartao = larguraCartao * 1.25 + 92 * escala;

        return RefreshIndicator(
          color: p.titulo,
          onRefresh: estado.carregarDados,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _cabecalho(larga, margem)),
              SliverToBoxAdapter(child: _filtros(estado, margem)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(margem, 6, margem, 14),
                  child: Text(
                    lista.length == 1 ? '1 perfume' : '${lista.length} perfumes',
                    style: TextStyle(fontSize: 12, color: p.textoSuave),
                  ),
                ),
              ),
              if (lista.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Center(
                      child: Text(
                        'Nenhum perfume encontrado.',
                        style: TextStyle(color: p.textoSuave),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(margem, 0, margem, 40),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colunas,
                      mainAxisSpacing: larga ? 28 : 20,
                      crossAxisSpacing: espaco,
                      mainAxisExtent: alturaCartao,
                    ),
                    itemCount: lista.length,
                    itemBuilder: (_, i) => CartaoPerfume(perfume: lista[i]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _cabecalho(bool larga, double margem) {
    final p = context.paleta;

    final textos = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vitrine olfativa',
          style: TextStyle(
            fontFamily: fonteTitulo,
            fontWeight: FontWeight.w500,
            fontSize: larga ? 36 : 26,
            color: p.titulo,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Descubra perfumes pelas suas notas',
          style: TextStyle(fontSize: larga ? 14 : 13, color: p.textoSuave),
        ),
      ],
    );

    final busca = TextField(
      controller: _controladorBusca,
      onChanged: (v) => setState(() => _busca = v),
      style: TextStyle(color: p.texto, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Buscar perfume, marca ou nota',
        hintStyle: TextStyle(color: p.textoSuave, fontSize: 14),
        filled: true,
        fillColor: p.superficie,
        prefixIcon: Icon(Icons.search, color: p.textoSuave),
        suffixIcon: _busca.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _controladorBusca.clear();
                  setState(() => _busca = '');
                },
                icon: Icon(Icons.close, color: p.textoSuave),
              ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: p.borda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: p.borda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: p.destaque, width: 1.4),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(margem, larga ? 32 : 20, margem, 16),
      child: larga
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: textos),
                const SizedBox(width: 24),
                SizedBox(width: 400, child: busca),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [textos, const SizedBox(height: 16), busca],
            ),
    );
  }

  Widget _filtros(GerenciadorEstado estado, double margem) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: margem),
        children: [
          _chip('Todos', _familia == null, () => setState(() => _familia = null)),
          for (final f in estado.familias)
            _chip(f, _familia == f, () => setState(() => _familia = f)),
        ],
      ),
    );
  }

  Widget _chip(String rotulo, bool selecionado, VoidCallback onTap) {
    final p = context.paleta;
    final esquema = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(rotulo),
        selected: selecionado,
        showCheckmark: false,
        selectedColor: p.titulo,
        backgroundColor: Colors.transparent,
        side: BorderSide(color: selecionado ? p.titulo : p.borda),
        shape: const StadiumBorder(),
        labelStyle: TextStyle(
          fontSize: 13,
          color: selecionado ? esquema.onPrimary : p.texto,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

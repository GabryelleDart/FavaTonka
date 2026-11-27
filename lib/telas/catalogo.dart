// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:favatonka/api/servicos.dart';
import 'package:favatonka/autenticador.dart';
import 'package:favatonka/componentes/cartao_perfume.dart';
import 'package:favatonka/componentes/logo.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/favoritos.dart';
import 'package:favatonka/telas/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Quantos perfumes o app pede ao serviço de cada vez (lazy-loading).
const int TAMANHO_PAGINA = 6;

class TelaCatalogo extends StatefulWidget {
  const TelaCatalogo({super.key});

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  final ServicoPerfumes _servico = ServicoPerfumes();
  final ScrollController _rolagem = ScrollController();
  final TextEditingController _controladorBusca = TextEditingController();
  Timer? _esperaDigitacao;

  final List<Perfume> _perfumes = [];
  List<String> _familias = [];

  int _ultimoId = 0; // id do último perfume recebido (marcador da paginação)
  bool _carregando = false;
  bool _temMais = true;
  bool _erro = false;

  String _textoDigitado = '';
  String _busca = ''; // o que já foi enviado ao serviço
  String? _familia;

  // Cada nova busca ou filtro aumenta este número. Respostas antigas, que
  // chegam atrasadas, são descartadas.
  int _geracao = 0;

  @override
  void initState() {
    super.initState();

    _rolagem.addListener(_aoRolar);
    _carregarFamilias();
    _carregarMais();
  }

  @override
  void dispose() {
    _esperaDigitacao?.cancel();
    _rolagem.dispose();
    _controladorBusca.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- lazy-loading

  /// Quando faltam menos de 400 pixels para o fim da lista, pede a próxima página.
  void _aoRolar() {
    if (_rolagem.hasClients && _rolagem.position.extentAfter < 400) {
      _carregarMais();
    }
  }

  Future<void> _carregarMais() async {
    if (_carregando || !_temMais || _erro) return;

    final geracao = _geracao;
    setState(() => _carregando = true);

    try {
      final lote = await _servico.listar(
        ultimoId: _ultimoId,
        tamanho: TAMANHO_PAGINA,
        busca: _busca,
        familia: _familia,
      );
      if (!mounted || geracao != _geracao) return;

      setState(() {
        _perfumes.addAll(lote);
        if (lote.isNotEmpty) _ultimoId = lote.last.id;
        _temMais = lote.length == TAMANHO_PAGINA;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted || geracao != _geracao) return;
      setState(() {
        _erro = true;
        _carregando = false;
      });
      return;
    }

    // Se a lista ainda não encheu a tela (não há o que rolar), pede mais.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_rolagem.hasClients && _rolagem.position.maxScrollExtent <= 0) {
        _carregarMais();
      }
    });
  }

  Future<void> _carregarFamilias() async {
    try {
      final familias = await _servico.familias();
      if (!mounted) return;
      setState(() => _familias = familias);
    } catch (e) {
      // sem as famílias o app continua funcionando, só não mostra os filtros
      debugPrint('Erro ao carregar famílias: $e');
    }
  }

  /// Volta ao começo da lista (nova busca, novo filtro ou "puxar para atualizar").
  Future<void> _reiniciar() async {
    _geracao++;
    setState(() {
      _perfumes.clear();
      _ultimoId = 0;
      _temMais = true;
      _erro = false;
      _carregando = false;
    });
    if (_familias.isEmpty) _carregarFamilias();
    await _carregarMais();
  }

  /// Busca em tempo real: espera uma pausa curta na digitação e consulta o serviço.
  void _aoDigitar(String texto) {
    setState(() => _textoDigitado = texto);

    _esperaDigitacao?.cancel();
    _esperaDigitacao = Timer(const Duration(milliseconds: 250), () {
      _busca = texto.trim();
      _reiniciar();
    });
  }

  void _limparBusca() {
    _esperaDigitacao?.cancel();
    _controladorBusca.clear();
    setState(() => _textoDigitado = '');
    _busca = '';
    _reiniciar();
  }

  void _escolherFamilia(String? familia) {
    _familia = familia;
    _reiniciar();
  }

  // ---------------------------------------------------------------- botões do topo

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

  // ---------------------------------------------------------------- tela

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
          child: _corpo(),
        ),
      ),
    );
  }

  Widget _corpo() {
    final p = context.paleta;

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

        final semResultado = _perfumes.isEmpty && !_carregando && !_erro;

        return RefreshIndicator(
          color: p.titulo,
          onRefresh: _reiniciar,
          child: CustomScrollView(
            controller: _rolagem,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _cabecalho(larga, margem)),
              SliverToBoxAdapter(child: _filtros(margem)),
              const SliverToBoxAdapter(child: SizedBox(height: 14)),
              if (_perfumes.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: margem),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colunas,
                      mainAxisSpacing: larga ? 28 : 20,
                      crossAxisSpacing: espaco,
                      mainAxisExtent: alturaCartao,
                    ),
                    itemCount: _perfumes.length,
                    itemBuilder: (_, i) => CartaoPerfume(perfume: _perfumes[i]),
                  ),
                ),
              if (semResultado)
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
                ),
              SliverToBoxAdapter(child: _rodape()),
            ],
          ),
        );
      },
    );
  }

  /// Parte de baixo da lista: indicador de carregamento, erro ou fim.
  Widget _rodape() {
    final p = context.paleta;

    if (_carregando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_erro) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            Text(
              'Não foi possível carregar os perfumes.\nConfira se os containers estão rodando.',
              textAlign: TextAlign.center,
              style: TextStyle(color: p.textoSuave, height: 1.5),
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

    if (!_temMais && _perfumes.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'Fim da vitrine',
            style: TextStyle(fontSize: 12, color: p.textoSuave),
          ),
        ),
      );
    }

    return const SizedBox(height: 40);
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
      onChanged: _aoDigitar,
      style: TextStyle(color: p.texto, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Buscar perfume, marca ou nota',
        hintStyle: TextStyle(color: p.textoSuave, fontSize: 14),
        filled: true,
        fillColor: p.superficie,
        prefixIcon: Icon(Icons.search, color: p.textoSuave),
        suffixIcon: _textoDigitado.isEmpty
            ? null
            : IconButton(
                onPressed: _limparBusca,
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

  Widget _filtros(double margem) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: margem),
        children: [
          _chip('Todos', _familia == null, () => _escolherFamilia(null)),
          for (final f in _familias)
            _chip(f, _familia == f, () => _escolherFamilia(f)),
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

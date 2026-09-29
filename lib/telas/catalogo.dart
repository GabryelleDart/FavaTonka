import 'package:favatonka/autenticador.dart';
import 'package:favatonka/componentes/cartao_perfume.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FavaTonka',
          style: TextStyle(
            fontFamily: fonteTitulo,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.6,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _abrirFavoritos(estado),
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Favoritos',
          ),
          IconButton(
            onPressed: () => _loginLogoff(estado),
            icon: Icon(estado.logado ? Icons.logout : Icons.login),
            tooltip: estado.logado ? 'Sair' : 'Entrar',
          ),
        ],
      ),
      body: _corpo(estado),
    );
  }

  Widget _corpo(GerenciadorEstado estado) {
    if (estado.carregando && estado.perfumes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (estado.erro != null && estado.perfumes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(estado.erro!),
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            controller: _controladorBusca,
            onChanged: (v) => setState(() => _busca = v),
            decoration: InputDecoration(
              hintText: 'Buscar por perfume, marca ou nota...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _busca.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _controladorBusca.clear();
                        setState(() => _busca = '');
                      },
                      icon: const Icon(Icons.close),
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _chip('Todos', _familia == null, () => setState(() => _familia = null)),
              for (final f in estado.familias)
                _chip(f, _familia == f, () => setState(() => _familia = f)),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: Cores.vinho,
            onRefresh: estado.carregarDados,
            child: lista.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('Nenhum perfume encontrado.')),
                    ],
                  )
                : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.66,
                    ),
                    itemCount: lista.length,
                    itemBuilder: (_, i) => CartaoPerfume(perfume: lista[i]),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String rotulo, bool selecionado, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(rotulo),
        selected: selecionado,
        showCheckmark: false,
        selectedColor: Cores.vinho,
        backgroundColor: Colors.white,
        side: BorderSide.none,
        labelStyle: TextStyle(color: selecionado ? Colors.white : Cores.vinho),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

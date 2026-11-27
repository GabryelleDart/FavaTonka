// ignore_for_file: constant_identifier_names

import 'package:favatonka/api/servicos.dart';
import 'package:favatonka/componentes/avatar_nota.dart';
import 'package:favatonka/componentes/cartao_comentario.dart';
import 'package:favatonka/componentes/foto_perfume.dart';
import 'package:favatonka/componentes/logo.dart';
import 'package:favatonka/componentes/piramide_olfativa.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/modelos/comentario.dart';
import 'package:favatonka/modelos/nota.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

/// Quantos comentários o app pede ao serviço de cada vez (lazy-loading).
const int TAMANHO_PAGINA_COMENTARIOS = 5;

void abrirDetalhes(BuildContext context, Perfume perfume, String heroTag) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => TelaDetalhes(perfumeInicial: perfume, heroTag: heroTag),
    ),
  );
}

class TelaDetalhes extends StatefulWidget {
  /// Perfume como veio da lista. Serve para mostrar foto e nome na hora,
  /// enquanto o serviço devolve a descrição e a pirâmide completa.
  final Perfume perfumeInicial;
  final String heroTag;

  const TelaDetalhes({super.key, required this.perfumeInicial, required this.heroTag});

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  final ServicoPerfumes _servicoPerfumes = ServicoPerfumes();
  final ServicoComentarios _servicoComentarios = ServicoComentarios();
  final TextEditingController _novoComentario = TextEditingController();
  final ScrollController _rolagem = ScrollController();

  Perfume? _completo; // perfume com descrição e pirâmide, vindo do serviço
  bool _erroPerfume = false;

  final List<Comentario> _comentarios = [];
  int _ultimoComentario = ultimoIdInicial;
  bool _carregandoComentarios = false;
  bool _temMaisComentarios = true;
  bool _erroComentarios = false;

  int get _idPerfume => widget.perfumeInicial.id;

  @override
  void initState() {
    super.initState();

    _rolagem.addListener(_aoRolar);
    _carregarPerfume();
    _carregarComentarios();
  }

  @override
  void dispose() {
    _novoComentario.dispose();
    _rolagem.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- carregamento

  Future<void> _carregarPerfume() async {
    setState(() => _erroPerfume = false);
    try {
      final perfume = await _servicoPerfumes.obter(_idPerfume);
      if (!mounted) return;
      setState(() => _completo = perfume);
    } catch (e) {
      if (!mounted) return;
      setState(() => _erroPerfume = true);
    }
  }

  /// Lazy-loading dos comentários: perto do fim da página, pede os próximos.
  void _aoRolar() {
    if (_erroComentarios) return;
    if (_rolagem.hasClients && _rolagem.position.extentAfter < 300) {
      _carregarComentarios();
    }
  }

  Future<void> _carregarComentarios() async {
    if (_carregandoComentarios || !_temMaisComentarios) return;

    setState(() {
      _carregandoComentarios = true;
      _erroComentarios = false;
    });

    try {
      final lote = await _servicoComentarios.listar(
        perfumeId: _idPerfume,
        ultimoId: _ultimoComentario,
        tamanho: TAMANHO_PAGINA_COMENTARIOS,
      );
      if (!mounted) return;

      setState(() {
        _comentarios.addAll(lote);
        if (lote.isNotEmpty) _ultimoComentario = lote.last.id;
        _temMaisComentarios = lote.length == TAMANHO_PAGINA_COMENTARIOS;
        _carregandoComentarios = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _carregandoComentarios = false;
        _erroComentarios = true;
      });
    }
  }

  void _reiniciarComentarios() {
    setState(() {
      _comentarios.clear();
      _ultimoComentario = ultimoIdInicial;
      _temMaisComentarios = true;
      _carregandoComentarios = false;
      _erroComentarios = false;
    });
    _carregarComentarios();
  }

  // ---------------------------------------------------------------- ações

  void _pedirLogin(String motivo) {
    final messenger = ScaffoldMessenger.of(context);
    final navegador = Navigator.of(context);

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(motivo),
        action: SnackBarAction(
          label: 'ENTRAR',
          onPressed: () => navegador.push(
            MaterialPageRoute(builder: (_) => const TelaLogin()),
          ),
        ),
      ),
    );
  }

  Future<void> _favoritar(GerenciadorEstado estado, Perfume perfume) async {
    if (!estado.logado) {
      _pedirLogin('Entre para favoritar perfumes');
      return;
    }

    final eraFavorito = estado.ehFavorito(perfume.id);
    final ok = await estado.alternarFavorito(perfume.id);
    if (!mounted) return;

    if (!ok) {
      avisar(context, 'Não foi possível atualizar os favoritos');
      return;
    }
    avisar(
      context,
      eraFavorito
          ? '${perfume.nome} removido dos favoritos'
          : '${perfume.nome} adicionado aos favoritos',
    );
  }

  void _compartilhar(Perfume perfume) {
    final notas = (perfume.todasNotas.isNotEmpty ? perfume.todasNotas : perfume.notasPreview)
        .take(5)
        .map((n) => n.nome)
        .join(', ');
    final titulo = perfume.marca.isEmpty ? perfume.nome : '${perfume.nome} — ${perfume.marca}';
    final texto = notas.isEmpty
        ? '$titulo, conheça no FavaTonka!'
        : '$titulo\nNotas: $notas\n\nConheça no FavaTonka!';

    SharePlus.instance.share(ShareParams(title: 'FavaTonka', text: texto));
  }

  Future<void> _enviarComentario(GerenciadorEstado estado) async {
    final texto = _novoComentario.text.trim();
    final usuario = estado.usuario;
    if (texto.isEmpty || usuario == null) return;

    try {
      final ok = await _servicoComentarios.adicionar(_idPerfume, usuario, texto);
      if (!mounted) return;

      if (ok) {
        _novoComentario.clear();
        FocusScope.of(context).unfocus();
        _reiniciarComentarios(); // recarrega do começo: o novo aparece no topo
        avisar(context, 'Comentário adicionado');
      } else {
        avisar(context, 'Não foi possível enviar o comentário');
      }
    } catch (e) {
      if (!mounted) return;
      avisar(context, 'Não foi possível enviar o comentário');
    }
  }

  Future<void> _apagarComentario(GerenciadorEstado estado, Comentario comentario) async {
    final usuario = estado.usuario;
    if (usuario == null) return;

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text('Deseja apagar o comentário?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('NÃO'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('SIM'),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    try {
      final ok = await _servicoComentarios.remover(comentario.id, usuario);
      if (!mounted) return;

      if (ok) {
        setState(() => _comentarios.removeWhere((c) => c.id == comentario.id));
      } else {
        avisar(context, 'Não foi possível apagar o comentário');
      }
    } catch (e) {
      if (!mounted) return;
      avisar(context, 'Não foi possível apagar o comentário');
    }
  }

  void _mostrarNota(Nota nota, Perfume atual) {
    final p = context.paleta;
    final navegador = Navigator.of(context);
    // pergunta ao serviço em quais perfumes esta nota aparece
    final futuro = _servicoPerfumes.comNota(nota.chave);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.fundo,
      constraints: const BoxConstraints(maxWidth: 560),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarNota(nota: nota, tamanho: 104),
            const SizedBox(height: 14),
            Text(
              nota.nome,
              style: TextStyle(
                fontFamily: fonteTitulo,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: p.titulo,
              ),
            ),
            const SizedBox(height: 14),
            FutureBuilder<List<Perfume>>(
              future: futuro,
              builder: (ctx, resultado) {
                if (resultado.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  );
                }
                if (resultado.hasError) {
                  return Text(
                    'Não foi possível carregar os perfumes desta nota.',
                    style: TextStyle(color: p.textoSuave),
                  );
                }

                final outros = resultado.data!.where((x) => x.id != atual.id).toList();
                return Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        outros.isEmpty
                            ? 'Nenhum outro perfume da vitrine tem esta nota.'
                            : 'Também está em:',
                        style: TextStyle(color: p.textoSuave),
                      ),
                      if (outros.isNotEmpty)
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (final o in outros)
                                ListTile(
                                  leading: SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: ClipOval(child: FotoPerfume(perfume: o)),
                                  ),
                                  title: Text(o.nome, style: TextStyle(color: p.texto)),
                                  subtitle: o.marca.isEmpty
                                      ? null
                                      : Text(o.marca, style: TextStyle(color: p.textoSuave)),
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                    navegador.push(
                                      MaterialPageRoute(
                                        builder: (_) => TelaDetalhes(
                                          perfumeInicial: o,
                                          heroTag: 'nota-${o.id}',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- tela

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    final perfume = _completo ?? widget.perfumeInicial;
    final p = context.paleta;
    final larga = telaLarga(context);
    final favorito = estado.ehFavorito(perfume.id);

    final imagem = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: larga ? 4 / 5 : 1 / 1.05,
        child: Container(
          color: p.superficie,
          child: Hero(tag: widget.heroTag, child: FotoPerfume(perfume: perfume)),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Logo(tamanho: 24),
        actions: [
          IconButton(
            onPressed: () => _favoritar(estado, perfume),
            tooltip: 'Favoritar',
            icon: Icon(
              favorito ? Icons.favorite : Icons.favorite_border,
              color: favorito ? Colors.red : null,
            ),
          ),
          IconButton(
            onPressed: () => _compartilhar(perfume),
            tooltip: 'Compartilhar',
            icon: const Icon(Icons.share_outlined),
          ),
          SizedBox(width: larga ? 24 : 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: p.borda),
        ),
      ),
      body: SingleChildScrollView(
        controller: _rolagem,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: EdgeInsets.fromLTRB(larga ? 32 : 16, 20, larga ? 32 : 16, 48),
              child: larga
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: imagem),
                        const SizedBox(width: 56),
                        Expanded(flex: 6, child: _conteudo(estado, perfume)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imagem,
                        const SizedBox(height: 24),
                        _conteudo(estado, perfume),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _piramide(Perfume perfume) {
    final p = context.paleta;

    if (_completo == null) {
      if (_erroPerfume) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Não foi possível carregar as notas deste perfume.',
              style: TextStyle(color: p.textoSuave),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: _carregarPerfume, child: const Text('Tentar novamente')),
          ],
        );
      }
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!perfume.temNotas) {
      return Text(
        'As notas olfativas deste perfume serão adicionadas em breve.',
        style: TextStyle(color: p.textoSuave),
      );
    }

    return PiramideOlfativa(
      perfume: perfume,
      onNotaTap: (nota) => _mostrarNota(nota, perfume),
    );
  }

  Widget _conteudo(GerenciadorEstado estado, Perfume perfume) {
    final p = context.paleta;
    final subtitulo = [
      perfume.marca,
      if (perfume.ano != null) perfume.ano.toString(),
      perfume.genero,
    ].where((s) => s.isNotEmpty).join('  ·  ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          perfume.nome,
          style: TextStyle(
            fontFamily: fonteTitulo,
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: p.titulo,
            height: 1.15,
          ),
        ),
        if (subtitulo.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(subtitulo, style: TextStyle(color: p.textoSuave, fontSize: 14)),
          ),
        if (perfume.familias.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in perfume.familias)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: p.destaque.withValues(alpha: 0.7)),
                  ),
                  child: Text(f, style: TextStyle(fontSize: 12.5, color: p.titulo)),
                ),
            ],
          ),
        ],
        if (perfume.descricao.isNotEmpty) ...[
          const SizedBox(height: 22),
          Text(
            perfume.descricao,
            style: TextStyle(fontSize: 15, height: 1.7, color: p.texto),
          ),
        ],
        const SizedBox(height: 36),
        _Secao('Pirâmide olfativa', p),
        const SizedBox(height: 6),
        Text(
          'Toque em uma nota para ver onde mais ela aparece.',
          style: TextStyle(fontSize: 12, color: p.textoSuave),
        ),
        const SizedBox(height: 20),
        _piramide(perfume),
        const SizedBox(height: 20),
        _Secao('Comentários', p),
        const SizedBox(height: 16),
        _campoComentario(estado),
        ..._listaComentarios(estado),
      ],
    );
  }

  Widget _campoComentario(GerenciadorEstado estado) {
    final p = context.paleta;

    if (!estado.logado) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: p.titulo,
            side: BorderSide(color: p.destaque),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TelaLogin()),
          ),
          icon: const Icon(Icons.person_outline),
          label: const Text('Entre para comentar'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: _novoComentario,
        textInputAction: TextInputAction.send,
        maxLength: 500,
        style: TextStyle(color: p.texto),
        onSubmitted: (_) => _enviarComentario(estado),
        decoration: InputDecoration(
          hintText: 'Escreva seu comentário...',
          hintStyle: TextStyle(color: p.textoSuave, fontSize: 14),
          counterText: '',
          filled: true,
          fillColor: p.superficie,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
          suffixIcon: IconButton(
            onPressed: () => _enviarComentario(estado),
            icon: Icon(Icons.send, color: p.titulo),
            tooltip: 'Enviar',
          ),
        ),
      ),
    );
  }

  List<Widget> _listaComentarios(GerenciadorEstado estado) {
    final p = context.paleta;

    return [
      if (_comentarios.isEmpty && !_carregandoComentarios && !_erroComentarios)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text('Ainda não há comentários.', style: TextStyle(color: p.textoSuave)),
        ),
      for (final c in _comentarios)
        CartaoComentario(
          comentario: c,
          doUsuarioLogado: estado.usuario?.email == c.email,
          onApagar: () => _apagarComentario(estado, c),
        ),
      if (_carregandoComentarios)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        ),
      if (_erroComentarios)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Text(
                'Não foi possível carregar os comentários.',
                style: TextStyle(color: p.textoSuave),
              ),
              TextButton(
                onPressed: _carregarComentarios,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      // Alternativa ao rolar: botão para quem não tem rolagem (ex.: janela larga)
      if (_temMaisComentarios && !_carregandoComentarios && !_erroComentarios && _comentarios.isNotEmpty)
        Center(
          child: TextButton(
            onPressed: _carregarComentarios,
            child: const Text('Ver mais comentários'),
          ),
        ),
    ];
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final Paleta paleta;

  const _Secao(this.titulo, this.paleta);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 22, color: paleta.destaque),
        const SizedBox(width: 12),
        Text(
          titulo,
          style: TextStyle(
            fontFamily: fonteTitulo,
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: paleta.titulo,
          ),
        ),
      ],
    );
  }
}

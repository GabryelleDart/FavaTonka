import 'package:favatonka/componentes/avatar_nota.dart';
import 'package:favatonka/componentes/cartao_comentario.dart';
import 'package:favatonka/componentes/foto_perfume.dart';
import 'package:favatonka/componentes/piramide_olfativa.dart';
import 'package:favatonka/gerenciador_estado.dart';
import 'package:favatonka/modelos/nota.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:favatonka/telas/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

void abrirDetalhes(BuildContext context, int perfumeId, String heroTag) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => TelaDetalhes(perfumeId: perfumeId, heroTag: heroTag),
    ),
  );
}

class TelaDetalhes extends StatefulWidget {
  final int perfumeId;
  final String heroTag;

  const TelaDetalhes({super.key, required this.perfumeId, required this.heroTag});

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  final _novoComentario = TextEditingController();

  @override
  void dispose() {
    _novoComentario.dispose();
    super.dispose();
  }

  void _pedirLogin(String motivo) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(motivo),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'ENTRAR',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TelaLogin()),
          ),
        ),
      ),
    );
  }

  void _favoritar(GerenciadorEstado estado, Perfume perfume) {
    if (!estado.logado) {
      _pedirLogin('Entre para favoritar perfumes');
      return;
    }
    estado.alternarFavorito(perfume.id);
    avisar(
      context,
      estado.ehFavorito(perfume.id)
          ? '${perfume.nome} adicionado aos favoritos'
          : '${perfume.nome} removido dos favoritos',
    );
  }

  void _compartilhar(GerenciadorEstado estado, Perfume perfume) {
    final notas = perfume.todasNotas.take(5).map((k) => estado.nota(k).nome).join(', ');
    final titulo = perfume.marca.isEmpty ? perfume.nome : '${perfume.nome} — ${perfume.marca}';
    final texto = notas.isEmpty
        ? '$titulo, conheça no FavaTonka!'
        : '$titulo\nNotas: $notas\n\nConheça no FavaTonka!';

    SharePlus.instance.share(ShareParams(title: 'FavaTonka', text: texto));
  }

  void _enviarComentario(GerenciadorEstado estado, Perfume perfume) {
    final texto = _novoComentario.text.trim();
    if (texto.isEmpty) return;

    estado.adicionarComentario(perfume.id, texto);
    _novoComentario.clear();
    FocusScope.of(context).unfocus();
    avisar(context, 'Comentário adicionado');
  }

  Future<void> _apagarComentario(GerenciadorEstado estado, int id) async {
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

    if (confirmou == true) estado.removerComentario(id);
  }

  void _mostrarNota(GerenciadorEstado estado, Nota nota, Perfume atual) {
    final outros = estado.perfumesComNota(nota.chave).where((p) => p.id != atual.id).toList();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Cores.creme,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarNota(nota: nota, tamanho: 104),
            const SizedBox(height: 12),
            Text(
              nota.nome,
              style: const TextStyle(
                fontFamily: fonteTitulo,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Cores.vinho,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              outros.isEmpty
                  ? 'Nenhum outro perfume da vitrine tem esta nota.'
                  : 'Também está em:',
              style: const TextStyle(color: Colors.black54),
            ),
            if (outros.isNotEmpty)
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final p in outros)
                      ListTile(
                        leading: SizedBox(
                          width: 44,
                          height: 44,
                          child: ClipOval(child: FotoPerfume(perfume: p)),
                        ),
                        title: Text(p.nome),
                        subtitle: p.marca.isEmpty ? null : Text(p.marca),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          abrirDetalhes(context, p.id, 'nota-${p.id}');
                        },
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = context.watch<GerenciadorEstado>();
    final perfume = estado.perfumePorId(widget.perfumeId);

    if (perfume == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Perfume não encontrado')),
      );
    }

    final favorito = estado.ehFavorito(perfume.id);
    final comentarios = estado.comentariosDe(perfume.id);
    final subtitulo = [
      perfume.marca,
      if (perfume.ano != null) perfume.ano.toString(),
      perfume.genero,
    ].where((s) => s.isNotEmpty).join(' · ');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
            backgroundColor: Cores.creme,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: IconButton.filledTonal(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            actions: [
              IconButton.filledTonal(
                onPressed: () => _favoritar(estado, perfume),
                tooltip: 'Favoritar',
                icon: Icon(
                  favorito ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 4),
              IconButton.filledTonal(
                onPressed: () => _compartilhar(estado, perfume),
                tooltip: 'Compartilhar',
                icon: const Icon(Icons.share),
              ),
              const SizedBox(width: 10),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.heroTag,
                child: FotoPerfume(perfume: perfume),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    perfume.nome,
                    style: const TextStyle(
                      fontFamily: fonteTitulo,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Cores.vinho,
                    ),
                  ),
                  if (subtitulo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(subtitulo, style: const TextStyle(color: Colors.black54)),
                    ),
                  if (perfume.familias.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        for (final f in perfume.familias)
                          Chip(
                            label: Text(f),
                            backgroundColor: Cores.dourado.withValues(alpha: 0.18),
                            side: BorderSide.none,
                          ),
                      ],
                    ),
                  ],
                  if (perfume.descricao.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      perfume.descricao,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                  const SizedBox(height: 26),
                  const _Secao('Pirâmide olfativa'),
                  const SizedBox(height: 4),
                  const Text(
                    'Toque em uma nota para ver onde mais ela aparece.',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                  const SizedBox(height: 14),
                  if (perfume.temNotas)
                    PiramideOlfativa(
                      perfume: perfume,
                      onNotaTap: (n) => _mostrarNota(estado, n, perfume),
                    )
                  else
                    const Text(
                      'As notas olfativas deste perfume serão adicionadas em breve.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  const SizedBox(height: 14),
                  const _Secao('Comentários'),
                  const SizedBox(height: 12),
                  if (estado.logado)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: TextField(
                        controller: _novoComentario,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _enviarComentario(estado, perfume),
                        decoration: InputDecoration(
                          hintText: 'Escreva seu comentário...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => _enviarComentario(estado, perfume),
                            icon: const Icon(Icons.send, color: Cores.vinho),
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const TelaLogin()),
                        ),
                        icon: const Icon(Icons.login),
                        label: const Text('Entre para comentar'),
                      ),
                    ),
                  if (comentarios.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Ainda não há comentários.',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    )
                  else
                    for (final c in comentarios)
                      CartaoComentario(
                        comentario: c,
                        doUsuarioLogado: estado.usuario?.email == c.email,
                        onApagar: () => _apagarComentario(estado, c.id),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;

  const _Secao(this.titulo);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 22, color: Cores.dourado),
        const SizedBox(width: 10),
        Text(
          titulo,
          style: const TextStyle(
            fontFamily: fonteTitulo,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Cores.vinho,
          ),
        ),
      ],
    );
  }
}

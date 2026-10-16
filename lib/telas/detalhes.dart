import 'package:favatonka/componentes/avatar_nota.dart';
import 'package:favatonka/componentes/cartao_comentario.dart';
import 'package:favatonka/componentes/foto_perfume.dart';
import 'package:favatonka/componentes/logo.dart';
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
    final p = context.paleta;
    final outros = estado.perfumesComNota(nota.chave).where((x) => x.id != atual.id).toList();

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
                          abrirDetalhes(context, o.id, 'nota-${o.id}');
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
            onPressed: () => _compartilhar(estado, perfume),
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

  Widget _conteudo(GerenciadorEstado estado, Perfume perfume) {
    final p = context.paleta;
    final comentarios = estado.comentariosDe(perfume.id);
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
        if (perfume.temNotas)
          PiramideOlfativa(
            perfume: perfume,
            onNotaTap: (n) => _mostrarNota(estado, n, perfume),
          )
        else
          Text(
            'As notas olfativas deste perfume serão adicionadas em breve.',
            style: TextStyle(color: p.textoSuave),
          ),
        const SizedBox(height: 20),
        _Secao('Comentários', p),
        const SizedBox(height: 16),
        if (estado.logado)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: _novoComentario,
              textInputAction: TextInputAction.send,
              style: TextStyle(color: p.texto),
              onSubmitted: (_) => _enviarComentario(estado, perfume),
              decoration: InputDecoration(
                hintText: 'Escreva seu comentário...',
                hintStyle: TextStyle(color: p.textoSuave, fontSize: 14),
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
                  onPressed: () => _enviarComentario(estado, perfume),
                  icon: Icon(Icons.send, color: p.titulo),
                  tooltip: 'Enviar',
                ),
              ),
            ),
          )
        else
          Padding(
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
          ),
        if (comentarios.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text('Ainda não há comentários.', style: TextStyle(color: p.textoSuave)),
          )
        else
          for (final c in comentarios)
            CartaoComentario(
              comentario: c,
              doUsuarioLogado: estado.usuario?.email == c.email,
              onApagar: () => _apagarComentario(estado, c.id),
            ),
      ],
    );
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

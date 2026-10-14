import 'dart:convert';
import 'package:favatonka/modelos/comentario.dart';
import 'package:favatonka/modelos/nota.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Brightness, ThemeMode;
import 'package:flutter/services.dart';

class GerenciadorEstado extends ChangeNotifier {
  List<Perfume> _perfumes = [];
  Map<String, Nota> _notas = {};
  List<Comentario> _comentarios = [];

  bool _carregando = true;
  String? _erro;

  Usuario? _usuario;
  final Set<int> _favoritos = {};
  int _proximoIdComentario = 1000;
  ThemeMode _modoTema = ThemeMode.system;

  bool get carregando => _carregando;
  String? get erro => _erro;
  Usuario? get usuario => _usuario;
  bool get logado => _usuario != null;
  ThemeMode get modoTema => _modoTema;

  /// Alterna entre claro e escuro, partindo do tema que está na tela agora.
  void alternarTema(Brightness atual) {
    _modoTema = atual == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
  List<Perfume> get perfumes => List.unmodifiable(_perfumes);

  List<String> get familias {
    final conjunto = <String>{};
    for (final p in _perfumes) {
      conjunto.addAll(p.familias);
    }
    final lista = conjunto.toList()..sort();
    return lista;
  }

  // ---------- Carregamento dos JSONs estáticos ----------

  Future<void> carregarDados() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final perfumesJson =
          json.decode(await rootBundle.loadString('recursos/jsons/perfumes.json'))
              as Map<String, dynamic>;
      final notasJson =
          json.decode(await rootBundle.loadString('recursos/jsons/notas.json'))
              as Map<String, dynamic>;

      _perfumes = (perfumesJson['perfumes'] as List)
          .map((e) => Perfume.fromJson(e as Map<String, dynamic>))
          .toList();

      _notas = (notasJson['notas'] as Map<String, dynamic>).map(
        (chave, valor) =>
            MapEntry(chave, Nota.fromJson(chave, valor as Map<String, dynamic>)),
      );

      // Os comentários só são lidos uma vez, para não perder os novos
      // quando o usuário atualizar a lista.
      if (_comentarios.isEmpty) {
        final comentariosJson =
            json.decode(
                  await rootBundle.loadString('recursos/jsons/comentarios.json'),
                )
                as Map<String, dynamic>;
        _comentarios = (comentariosJson['comentarios'] as List)
            .map((e) => Comentario.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
      _erro = 'Não foi possível carregar os perfumes.';
    }

    _carregando = false;
    notifyListeners();
  }

  // ---------- Consultas ----------

  Nota nota(String chave) => _notas[chave] ?? Nota.desconhecida(chave);

  Perfume? perfumePorId(int id) {
    for (final p in _perfumes) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<Perfume> perfumesComNota(String chave) =>
      _perfumes.where((p) => p.todasNotas.contains(chave)).toList();

   /// Palavras pesquisáveis de um perfume: nome, marca e notas
  /// (em português e a chave em inglês, ex.: "baunilha" e "vanilla").
    // Palavrinhas que não ajudam na busca (ex.: "Lírio de Grasse").
  static const Set<String> _ignoradas = {'de', 'da', 'do', 'das', 'dos'};

  /// Palavras pesquisáveis de um perfume: nome, marca e notas
  /// (em português e a chave em inglês, ex.: "baunilha" e "vanilla").
  List<String> _palavrasDe(Perfume p) => [
        ..._palavras(p.nome),
        _compactar(p.nome),
        ..._palavras(p.marca),
        for (final k in p.todasNotas) ..._palavras('${nota(k).nome} $k'),
      ];

    List<Perfume> perfumesFiltrados(String busca, String? familia) {
    final termos = _palavras(busca);
    final compactoBusca = _compactar(busca);

    return _perfumes.where((p) {
      if (familia != null && !p.familias.contains(familia)) return false;
      if (termos.isEmpty) return true;

      // Cada termo digitado precisa ser o começo de alguma palavra do perfume
      // (nome, marca ou notas).
      final palavras = _palavrasDe(p);
      final porPalavras = termos.every(
        (t) => palavras.any((w) => w.startsWith(t)),
      );

      // Também aceita o nome "colado": "j adore" -> "jadore", "no 5" -> "no5".
      final porNome = _compactar(p.nome).startsWith(compactoBusca);

      return porPalavras || porNome;
    }).toList();
  }

  static List<String> _palavras(String texto) {
    return _normalizar(texto)
        .replaceAll(RegExp(r"['’`´]"), '') // J'adore vira "jadore"
        .split(RegExp(r'[^a-z0-9]+'))
        .where((w) => w.isNotEmpty && !_ignoradas.contains(w))
        .toList();
  }

  static String _compactar(String texto) =>
      _normalizar(texto).replaceAll(RegExp(r'[^a-z0-9]'), '');

  static String _normalizar(String texto) {
    const de = 'áàâãäéèêëíìîïóòôõöúùûüçºª';
    const para = 'aaaaaeeeeiiiiooooouuuucoa';
    var r = texto.toLowerCase();
    for (var i = 0; i < de.length; i++) {
      r = r.replaceAll(de[i], para[i]);
    }
    return r;
  }

  // ---------- Login / logoff ----------

  void login(Usuario usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    _favoritos.clear();
    notifyListeners();
  }

  // ---------- Favoritos (exigem login) ----------

  bool ehFavorito(int perfumeId) => _favoritos.contains(perfumeId);

  List<Perfume> get favoritos =>
      _perfumes.where((p) => _favoritos.contains(p.id)).toList();

  void alternarFavorito(int perfumeId) {
    if (!logado) return;
    if (!_favoritos.remove(perfumeId)) {
      _favoritos.add(perfumeId);
    }
    notifyListeners();
  }

  // ---------- Comentários (exigem login) ----------

  List<Comentario> comentariosDe(int perfumeId) {
    final lista = _comentarios.where((c) => c.perfumeId == perfumeId).toList();
    lista.sort((a, b) => b.data.compareTo(a.data));
    return lista;
  }

  void adicionarComentario(int perfumeId, String texto) {
    final u = _usuario;
    if (u == null) return;

    _comentarios.add(
      Comentario(
        id: _proximoIdComentario++,
        perfumeId: perfumeId,
        nome: u.nome,
        email: u.email,
        data: DateTime.now(),
        texto: texto,
      ),
    );
    notifyListeners();
  }

  void removerComentario(int comentarioId) {
    _comentarios.removeWhere((c) => c.id == comentarioId);
    notifyListeners();
  }
}

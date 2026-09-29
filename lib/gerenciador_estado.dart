import 'dart:convert';

import 'package:favatonka/modelos/comentario.dart';
import 'package:favatonka/modelos/nota.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/usuario.dart';
import 'package:flutter/foundation.dart';
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

  bool get carregando => _carregando;
  String? get erro => _erro;
  Usuario? get usuario => _usuario;
  bool get logado => _usuario != null;
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

  List<Perfume> perfumesFiltrados(String busca, String? familia) {
    final termo = _normalizar(busca);

    return _perfumes.where((p) {
      if (familia != null && !p.familias.contains(familia)) return false;
      if (termo.isEmpty) return true;

      final alvo = [
        p.nome,
        p.marca,
        ...p.todasNotas.map((k) => nota(k).nome),
      ].map(_normalizar).join(' ');
      return alvo.contains(termo);
    }).toList();
  }

  static String _normalizar(String texto) {
    const de = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const para = 'aaaaaeeeeiiiiooooouuuuc';
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

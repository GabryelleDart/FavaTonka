import 'package:favatonka/api/servicos.dart';
import 'package:favatonka/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Brightness, ThemeMode;

/// Estado global do app: usuário logado, favoritos (que vêm do serviço
/// "favoritos") e tema. A lista de perfumes e os comentários agora são
/// carregados pelas próprias telas, página por página.
class GerenciadorEstado extends ChangeNotifier {
  final ServicoFavoritos _servicoFavoritos = ServicoFavoritos();

  Usuario? _usuario;
  Set<int> _favoritos = {};
  ThemeMode _modoTema = ThemeMode.system;

  Usuario? get usuario => _usuario;
  bool get logado => _usuario != null;
  ThemeMode get modoTema => _modoTema;

  /// Alterna entre claro e escuro, partindo do tema que está na tela agora.
  void alternarTema(Brightness atual) {
    _modoTema = atual == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // ---------- Login / logoff (login simulado, como na Avaliação I) ----------

  Future<void> login(Usuario usuario) async {
    _usuario = usuario;
    notifyListeners();

    // busca no serviço "favoritos" quais perfumes este usuário já favoritou
    try {
      _favoritos = await _servicoFavoritos.ids(usuario);
    } catch (e) {
      debugPrint('Erro ao carregar favoritos: $e');
      _favoritos = {};
    }
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    _favoritos = {};
    notifyListeners();
  }

  // ---------- Favoritos (exigem login) ----------

  bool ehFavorito(int perfumeId) => _favoritos.contains(perfumeId);

  /// Favorita ou desfavorita no serviço. Devolve false se algo deu errado.
  Future<bool> alternarFavorito(int perfumeId) async {
    final usuario = _usuario;
    if (usuario == null) return false;

    try {
      if (_favoritos.contains(perfumeId)) {
        await _servicoFavoritos.desfavoritar(usuario, perfumeId);
        _favoritos = {..._favoritos}..remove(perfumeId);
      } else {
        await _servicoFavoritos.favoritar(usuario, perfumeId);
        _favoritos = {..._favoritos, perfumeId};
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao alternar favorito: $e');
      return false;
    }
  }
}

import 'dart:convert';

import 'package:favatonka/api/configuracao.dart';
import 'package:favatonka/modelos/comentario.dart';
import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/usuario.dart';
import 'package:http/http.dart' as http;

/// Valor usado como "ainda não carreguei nada" na paginação dos comentários
/// (que vão do mais novo para o mais antigo).
const int ultimoIdInicial = 2147483647;

const Duration _limiteDeEspera = Duration(seconds: 10);

class ErroServico implements Exception {
  final String mensagem;

  ErroServico(this.mensagem);

  @override
  String toString() => mensagem;
}

dynamic _decodificar(http.Response resposta) =>
    jsonDecode(utf8.decode(resposta.bodyBytes));

Future<http.Response> _get(Uri uri) => http.get(uri).timeout(_limiteDeEspera);

// ---------------------------------------------------------------- perfumes

class ServicoPerfumes {
  /// Lazy-loading: devolve a próxima página de perfumes depois de [ultimoId].
  Future<List<Perfume>> listar({
    required int ultimoId,
    required int tamanho,
    String busca = '',
    String? familia,
  }) async {
    final filtros = <String, String>{
      if (busca.isNotEmpty) 'busca': busca,
      if (familia != null) 'familia': familia,
    };

    final uri = Uri.parse(
      '$urlPerfumes/$ultimoId/$tamanho',
    ).replace(queryParameters: filtros.isEmpty ? null : filtros);

    final resposta = await _get(uri);
    if (resposta.statusCode != 200) {
      throw ErroServico('erro ao buscar perfumes');
    }

    return (_decodificar(resposta) as List)
        .map((e) => Perfume.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Perfume> obter(int id) async {
    final resposta = await _get(Uri.parse('$urlPerfumes/$id'));
    if (resposta.statusCode != 200) {
      throw ErroServico('perfume não encontrado');
    }
    return Perfume.fromJson(_decodificar(resposta) as Map<String, dynamic>);
  }

  Future<List<String>> familias() async {
    final resposta = await _get(Uri.parse('$urlPerfumes/familias'));
    if (resposta.statusCode != 200) {
      throw ErroServico('erro ao buscar as famílias');
    }
    return List<String>.from(_decodificar(resposta) as List);
  }

  Future<List<Perfume>> comNota(String chaveDaNota) async {
    final resposta = await _get(
      Uri.parse('$urlPerfumes/notas/${Uri.encodeComponent(chaveDaNota)}/perfumes'),
    );
    if (resposta.statusCode != 200) {
      throw ErroServico('erro ao buscar os perfumes da nota');
    }
    return (_decodificar(resposta) as List)
        .map((e) => Perfume.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

// ---------------------------------------------------------------- comentários

class ServicoComentarios {
  /// Lazy-loading: devolve os próximos comentários mais antigos que [ultimoId].
  Future<List<Comentario>> listar({
    required int perfumeId,
    required int ultimoId,
    required int tamanho,
  }) async {
    final resposta = await _get(
      Uri.parse('$urlComentarios/$perfumeId/$ultimoId/$tamanho'),
    );
    if (resposta.statusCode != 200) {
      throw ErroServico('erro ao buscar comentários');
    }
    return (_decodificar(resposta) as List)
        .map((e) => Comentario.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> adicionar(int perfumeId, Usuario usuario, String texto) async {
    final resposta = await http
        .post(
          Uri.parse('$urlComentarios/$perfumeId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nome': usuario.nome,
            'email': usuario.email,
            'texto': texto,
          }),
        )
        .timeout(_limiteDeEspera);

    return resposta.statusCode == 201;
  }

  Future<bool> remover(int comentarioId, Usuario usuario) async {
    final resposta = await http
        .delete(
          Uri.parse('$urlComentarios/$comentarioId').replace(
            queryParameters: {'email': usuario.email},
          ),
        )
        .timeout(_limiteDeEspera);

    return resposta.statusCode == 200;
  }
}

// ---------------------------------------------------------------- favoritos

class ServicoFavoritos {
  String _email(Usuario usuario) => Uri.encodeComponent(usuario.email);

  Future<Set<int>> ids(Usuario usuario) async {
    final resposta = await _get(
      Uri.parse('$urlFavoritos/${_email(usuario)}/ids'),
    );
    if (resposta.statusCode != 200) {
      throw ErroServico('erro ao buscar favoritos');
    }
    return List<int>.from(_decodificar(resposta) as List).toSet();
  }

  /// Lazy-loading da tela de favoritos.
  Future<List<Perfume>> listar(
    Usuario usuario, {
    required int ultimoFavorito,
    required int tamanho,
  }) async {
    final resposta = await _get(
      Uri.parse('$urlFavoritos/${_email(usuario)}/$ultimoFavorito/$tamanho'),
    );
    if (resposta.statusCode != 200) {
      throw ErroServico('erro ao buscar favoritos');
    }
    return (_decodificar(resposta) as List)
        .map((e) => Perfume.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> favoritar(Usuario usuario, int perfumeId) async {
    final resposta = await http
        .post(Uri.parse('$urlFavoritos/${_email(usuario)}/$perfumeId'))
        .timeout(_limiteDeEspera);
    if (resposta.statusCode != 201) throw ErroServico('erro ao favoritar');
  }

  Future<void> desfavoritar(Usuario usuario, int perfumeId) async {
    final resposta = await http
        .delete(Uri.parse('$urlFavoritos/${_email(usuario)}/$perfumeId'))
        .timeout(_limiteDeEspera);
    if (resposta.statusCode != 200) throw ErroServico('erro ao desfavoritar');
  }
}

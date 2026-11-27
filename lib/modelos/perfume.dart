import 'package:favatonka/api/configuracao.dart';
import 'package:favatonka/modelos/nota.dart';

class Perfume {
  final int id;
  final String slug;
  final String nome;
  final String marca;
  final int? ano;
  final String genero;
  final String descricao;
  final List<String> familias;

  /// Pirâmide olfativa completa (só vem na tela de detalhes).
  final List<Nota> topo;
  final List<Nota> coracao;
  final List<Nota> fundo;

  /// Resumo para o cartão da lista (até 4 notas) e total de notas do perfume.
  final List<Nota> notasPreview;
  final int totalNotas;

  /// Caminho da foto no servidor de arquivos, ex.: perfumes/scandal.jpg
  final String foto;

  /// Só preenchido na lista de favoritos (serve de marcador da paginação).
  final int? idFavorito;

  const Perfume({
    required this.id,
    required this.slug,
    required this.nome,
    required this.marca,
    required this.ano,
    required this.genero,
    required this.descricao,
    required this.familias,
    required this.topo,
    required this.coracao,
    required this.fundo,
    required this.notasPreview,
    required this.totalNotas,
    required this.foto,
    required this.idFavorito,
  });

  /// Foto do frasco, entregue pelo container "arquivos" (nginx).
  String get urlFoto => '$urlArquivos/$foto';

  List<Nota> get todasNotas => [...topo, ...coracao, ...fundo];

  bool get temNotas => totalNotas > 0 || todasNotas.isNotEmpty;

  factory Perfume.fromJson(Map<String, dynamic> json) {
    List<Nota> notas(dynamic valor) => valor == null
        ? <Nota>[]
        : (valor as List)
              .map((e) => Nota.fromJson(e as Map<String, dynamic>))
              .toList();

    final piramide = (json['notas'] as Map<String, dynamic>?) ?? {};
    final topo = notas(piramide['topo']);
    final coracao = notas(piramide['coracao']);
    final fundo = notas(piramide['fundo']);

    return Perfume(
      id: json['id'] as int,
      slug: json['slug'] as String,
      nome: json['nome'] as String,
      marca: (json['marca'] as String?) ?? '',
      ano: json['ano'] as int?,
      genero: (json['genero'] as String?) ?? '',
      descricao: (json['descricao'] as String?) ?? '',
      familias: List<String>.from((json['familias'] as List?) ?? const []),
      topo: topo,
      coracao: coracao,
      fundo: fundo,
      notasPreview: notas(json['notas_preview']),
      totalNotas:
          (json['total_notas'] as int?) ?? (topo.length + coracao.length + fundo.length),
      foto: (json['foto'] as String?) ?? 'perfumes/${json['slug']}.jpg',
      idFavorito: json['favorito_id'] as int?,
    );
  }
}

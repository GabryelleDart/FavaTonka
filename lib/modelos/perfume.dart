class Perfume {
  final int id;
  final String slug;
  final String nome;
  final String marca;
  final int? ano;
  final String genero;
  final String descricao;
  final List<String> familias;
  final List<String> topo;
  final List<String> coracao;
  final List<String> fundo;

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
  });

  /// Foto do frasco. Se o arquivo não existir, o app desenha um frasco.
  String get caminhoFoto => 'recursos/imagens/perfumes/$slug.jpg';

  List<String> get todasNotas => [...topo, ...coracao, ...fundo];

  bool get temNotas => todasNotas.isNotEmpty;

  factory Perfume.fromJson(Map<String, dynamic> json) {
    final notas = (json['notas'] as Map<String, dynamic>?) ?? {};

    List<String> lista(dynamic valor) =>
        valor == null ? <String>[] : List<String>.from(valor as List);

    return Perfume(
      id: json['id'] as int,
      slug: json['slug'] as String,
      nome: json['nome'] as String,
      marca: (json['marca'] as String?) ?? '',
      ano: json['ano'] as int?,
      genero: (json['genero'] as String?) ?? '',
      descricao: (json['descricao'] as String?) ?? '',
      familias: lista(json['familias']),
      topo: lista(notas['topo']),
      coracao: lista(notas['coracao']),
      fundo: lista(notas['fundo']),
    );
  }
}

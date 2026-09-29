class Comentario {
  final int id;
  final int perfumeId;
  final String nome;
  final String email;
  final DateTime data;
  final String texto;

  const Comentario({
    required this.id,
    required this.perfumeId,
    required this.nome,
    required this.email,
    required this.data,
    required this.texto,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'] as int,
      perfumeId: json['perfumeId'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      data: DateTime.parse(json['data'] as String),
      texto: json['texto'] as String,
    );
  }
}

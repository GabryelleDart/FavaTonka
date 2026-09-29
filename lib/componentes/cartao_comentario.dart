import 'package:favatonka/modelos/comentario.dart';
import 'package:favatonka/tema.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartaoComentario extends StatelessWidget {
  final Comentario comentario;
  final bool doUsuarioLogado;
  final VoidCallback? onApagar;

  const CartaoComentario({
    super.key,
    required this.comentario,
    required this.doUsuarioLogado,
    this.onApagar,
  });

  @override
  Widget build(BuildContext context) {
    final data = DateFormat('dd/MM/yyyy HH:mm').format(comentario.data);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: doUsuarioLogado
            ? Cores.dourado.withValues(alpha: 0.16)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Cores.vinho,
            child: Text(
              comentario.nome.isNotEmpty ? comentario.nome[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comentario.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  data,
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
                const SizedBox(height: 6),
                Text(comentario.texto, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          if (doUsuarioLogado && onApagar != null)
            IconButton(
              onPressed: onApagar,
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              tooltip: 'Apagar comentário',
            ),
        ],
      ),
    );
  }
}

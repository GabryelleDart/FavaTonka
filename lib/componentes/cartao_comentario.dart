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
    final p = context.paleta;
    final data = DateFormat('dd/MM/yyyy HH:mm').format(comentario.data);
    final inicial = comentario.nome.isNotEmpty ? comentario.nome[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: doUsuarioLogado
            ? p.destaque.withValues(alpha: 0.14)
            : p.superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.borda),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: p.titulo,
            child: Text(
              inicial,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comentario.nome,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.5,
                    color: p.texto,
                  ),
                ),
                Text(data, style: TextStyle(fontSize: 11, color: p.textoSuave)),
                const SizedBox(height: 6),
                Text(
                  comentario.texto,
                  style: TextStyle(fontSize: 14, height: 1.45, color: p.texto),
                ),
              ],
            ),
          ),
          if (doUsuarioLogado && onApagar != null)
            IconButton(
              onPressed: onApagar,
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent,
              tooltip: 'Apagar comentário',
            ),
        ],
      ),
    );
  }
}

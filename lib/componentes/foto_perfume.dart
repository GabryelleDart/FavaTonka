import 'package:favatonka/modelos/perfume.dart';
import 'package:favatonka/tema.dart';
import 'package:flutter/material.dart';

/// Foto do perfume (recursos/imagens/perfumes/<slug>.jpg). Se o arquivo
/// ainda não existir, desenha um frasco estilizado como alternativa.
class FotoPerfume extends StatelessWidget {
  final Perfume perfume;
  final BoxFit fit;

  const FotoPerfume({super.key, required this.perfume, this.fit = BoxFit.cover});

  static const List<List<Color>> _paletas = [
    [Color(0xFF6A2C5B), Color(0xFF2E0F2A)],
    [Color(0xFFB5651D), Color(0xFF4B2A10)],
    [Color(0xFF8E5B7A), Color(0xFF3A1E33)],
    [Color(0xFF2F5D62), Color(0xFF12292C)],
    [Color(0xFFA0522D), Color(0xFF41200F)],
  ];

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      perfume.caminhoFoto,
      fit: fit,
      errorBuilder: (_, _, _) {
        final cores = _paletas[perfume.id % _paletas.length];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: cores,
            ),
          ),
          child: CustomPaint(painter: _FrascoPainter(), child: const SizedBox.expand()),
        );
      },
    );
  }
}

class _FrascoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final larguraCorpo = w * 0.42;

    final corpo = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, h * 0.60),
        width: larguraCorpo,
        height: h * 0.42,
      ),
      Radius.circular(w * 0.06),
    );
    final pescoco = Rect.fromCenter(
      center: Offset(cx, h * 0.35),
      width: larguraCorpo * 0.32,
      height: h * 0.08,
    );
    final tampa = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, h * 0.27),
        width: larguraCorpo * 0.5,
        height: h * 0.10,
      ),
      Radius.circular(w * 0.02),
    );

    final preenchimento = Paint()..color = Colors.white.withValues(alpha: 0.20);
    final borda = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Cores.dourado;
    final tampaPaint = Paint()..color = Cores.dourado;

    canvas.drawRRect(corpo, preenchimento);
    canvas.drawRRect(corpo, borda);
    canvas.drawRect(pescoco, preenchimento);
    canvas.drawRect(pescoco, borda);
    canvas.drawRRect(tampa, tampaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

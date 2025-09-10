import 'package:flutter/material.dart';

class UmbraLogo extends StatelessWidget {
  const UmbraLogo({super.key, this.size = 96});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CustomPaint(
        painter: _UmbraLogoPainter(
          glow: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _UmbraLogoPainter extends CustomPainter {
  _UmbraLogoPainter({required this.glow});
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    final shadowPaint = Paint()
      ..shader = RadialGradient(
        colors: [glow.withOpacity(0.55), Colors.transparent],
        stops: const [0, 1],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.4));
    canvas.drawCircle(center, radius * 1.2, shadowPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.18
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          Colors.red.shade400,
          Colors.red.shade800,
          Colors.red.shade400,
        ],
        stops: const [0, 0.6, 1],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.4,
      3.9,
      false,
      ringPaint,
    );

    final innerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF202020), Color(0xFF121212)],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.55));
    canvas.drawCircle(center, radius * 0.55, innerPaint);

    final cutPaint = Paint()
      ..color = Colors.black
      ..blendMode = BlendMode.clear;
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius * 0.28));
    canvas.saveLayer(Rect.fromCircle(center: center, radius: radius), Paint());
    // Use layer to apply clear blend
    canvas.drawPath(path, cutPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _UmbraLogoPainter oldDelegate) => false;
}

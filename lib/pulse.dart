library pulse;

import 'package:flutter/widgets.dart';

class Pulse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
class PulsePaint extends CustomPainter {
  final double radius;
  final Color color;
  final Offset offset;

  PulsePaint({
    this.radius,
    this.color,
    this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()..color = color;
      
    canvas.drawCircle(offset, radius, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

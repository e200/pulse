library pulse;

import 'package:flutter/widgets.dart';

class Pulse extends StatefulWidget {
  @override
  _PulseState createState() => _PulseState();
}
class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;


  @override
  void initState() {
    super.initState();

    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0.0,
    );

    if (widget.onComplete != null) {
      _animationController.addStatusListener((status) {
        if (_animationController.isCompleted) {
          widget.onComplete();
        }
      });
    }

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        curve: widget.curve ?? Curves.ease,
        parent: _animationController,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Opacity(
  }
}

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

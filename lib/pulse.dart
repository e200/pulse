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
    return AbsorbPointer(
      absorbing: _animationController.isAnimating,
      child: GestureDetector(
        onTapDown: (details) {
          _offsetNotifier.value = details.globalPosition;

          _animationController.forward(from: 0);

          widget.onTap?.call();
        },
        child: ValueListenableBuilder(
          valueListenable: _offsetNotifier,
          builder: (context, offset, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final _size = Size(constraints.maxWidth, constraints.maxHeight);
                final _circleRadius =
                    _hypotenuse(offset: offset, size: _size) * _animation.value;

    return Opacity(
                  opacity: widget.fadeIn ? _animation.value : 1,
                  child: CustomPaint(
                    size: _size,
                    painter: PulsePaint(
                      color: widget.pulseColor,
                      offset: offset,
                      radius: _circleRadius,
                    ),
                    child: widget.child,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
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

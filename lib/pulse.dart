library pulse;

import 'dart:math';

import 'package:flutter/widgets.dart';

class Pulse extends StatefulWidget {
  final Widget child;
  final Color pulseColor;
  final Curve curve;
  final BlendMode blendMode;
  final bool fadeIn;
  final Function onComplete;
  final Function onCancel;
  final Function onTap;

  const Pulse({
    Key key,
    @required this.pulseColor,
    @required this.onComplete,
    this.child,
    this.fadeIn = false,
    this.absorbConsecutivePointers = true,
    this.blendMode,
    this.curve,
    this.onTap,
    this.onCancel,
  }) : super(key: key);

  @override
  _PulseState createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  final _offsetNotifier = ValueNotifier(Offset.zero);

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

    _setupTween();
  }

  _setupTween() {
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

  double _hypotenuse({Offset offset, Size size}) {
    final _xDistance = offset.dx;
    final _yDistance = offset.dy;

    final _distanceFromOffsetToTheRightEdge = size.width - _xDistance;
    final _distanceFromOffsetToTheTopEdge = size.height - _yDistance;

    final _a = max(_distanceFromOffsetToTheRightEdge, _xDistance);
    final _b = max(_distanceFromOffsetToTheTopEdge, _yDistance);

    return sqrt(pow(_a, 2) + pow(_b, 2));
  }

  @override
  void didUpdateWidget(covariant Pulse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.curve != oldWidget.curve) {
      _setupTween();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing:
          widget.absorbConsecutivePointers && _animationController.isAnimating,
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
  final BlendMode blendMode;
  final double radius;
  final Color color;
  final Offset offset;

  PulsePaint({
    this.radius,
    this.color,
    this.offset,
    this.blendMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()..color = color;

    if (blendMode != null) {
      _paint.blendMode = blendMode;
    }

    canvas.drawCircle(offset, radius, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

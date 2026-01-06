import 'package:flutter/material.dart';

class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool shake;

  const ShakeAnimation({
    super.key,
    required this.child,
    required this.shake,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(covariant ShakeAnimation oldWidget) {
    if (widget.shake) {
      _controller.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final offset =
            10 * (0.5 - (_controller.value - 0.5).abs());
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
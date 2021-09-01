import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class AnimationView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final Widget child;

  const AnimationView({Key? key, required this.animationController, required this.animation, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: child,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressBar extends StatelessWidget {
  final double max;
  final double current;
  final Color color;
  final BorderRadiusGeometry? borderRadiusGeometry;
  const ProgressBar(
      {Key? key,
        required this.max,
        required this.current,
        this.color = Colors.red,
        this.borderRadiusGeometry})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 5,
              decoration: BoxDecoration(
                color: Color(0xffd3d3d3),
                borderRadius: borderRadiusGeometry??BorderRadius.circular(35),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: percent,
              height: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: max != current?BorderRadius.circular(35):borderRadiusGeometry??BorderRadius.circular(35),
              ),
            ),
          ],
        );
      },
    );
  }
}
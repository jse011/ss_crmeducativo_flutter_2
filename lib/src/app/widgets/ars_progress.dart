import 'dart:ui';

import 'package:flutter/material.dart';
class ArsProgressWidget extends StatelessWidget {
  /// Main widget of dialog,
  Widget? loadingWidget;

  /// This function will trigger when user dismisses dialog
  final Function? onDismiss;

  /// Amount of background blur
  final double blur;

  /// Dialog's background color
  final Color backgroundColor;

  /// Whether dialog can dismiss by touching outside or not
  final bool dismissable;

  /// Duration of blur and background color animation
  final Duration animationDuration;

  ArsProgressWidget({
    this.dismissable: true,
    this.onDismiss,
    this.backgroundColor: const Color(0x99000000),
    this.loadingWidget,
    this.blur:0,
    this.animationDuration: const Duration(milliseconds: 300),
  }) {
    loadingWidget = loadingWidget ??
        Container(
          padding: EdgeInsets.all(10.0),
          height: 100.0,
          width: 100.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return _DialogBackground(
      blur: blur,
      dismissable: dismissable,
      onDismiss: onDismiss,
      color: backgroundColor,
      animationDuration: animationDuration,
      dialog: Padding(
        padding: MediaQuery.of(context).viewInsets +
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Center(
          child: loadingWidget,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _DialogBackground extends StatelessWidget {
  /// Widget of dialog, you can use NDialog, Dialog, AlertDialog or Custom your own Dialog
  final Widget? dialog;

  /// Because blur dialog cover the barrier, you have to declare here
  final bool? dismissable;

  /// Action before dialog dismissed
  final Function? onDismiss;

  /// Creates an background filter that applies a Gaussian blur.
  /// Default = 0
  final double? blur;

  /// Background color
  final Color color;

  /// Animation Duration
  final Duration animationDuration;

  /// Color Opacity
  double? _colorOpacity;

  _DialogBackground(
      {this.dialog,
        this.dismissable,
        this.blur,
        this.onDismiss,
        this.animationDuration: const Duration(milliseconds: 300),
        this.color: Colors.red}) {
    _colorOpacity = color.opacity;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: animationDuration,
        builder: (context, val, child) {
          return Material(
            type: MaterialType.canvas,
            color: color.withOpacity(((val??0.0) as double)  * (_colorOpacity??0.0)),
            child: WillPopScope(
              onWillPop: () async {
                if (dismissable ?? true) {
                  if (onDismiss != null)onDismiss!();
                }
                return false;
              },
              child: Stack(
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: dismissable ?? true
                          ? () {
                        if (onDismiss != null) {
                          onDismiss!();
                        }

                      }
                          : () {},
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: (val as double) * (blur??0.0),
                          sigmaY: (val as double) * (blur??0.0),
                        ),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      )),
                  dialog??Container()
                ],
              ),
            ),
          );
        });
  }
}
import 'dart:async';
import 'dart:ui';

class AppDebouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  AppDebouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }


}
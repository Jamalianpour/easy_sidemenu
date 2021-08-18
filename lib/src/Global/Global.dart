import '../SideMenuDisplayMode.dart';
import '../SideMenuStyle.dart';
import 'package:flutter/widgets.dart';

class Global {
  static late PageController controller;
  static late SideMenuStyle style;
  static DisplayModeNotifier displayModeState =
      DisplayModeNotifier(SideMenuDisplayMode.auto);
}

class DisplayModeNotifier extends ValueNotifier<SideMenuDisplayMode> {
  DisplayModeNotifier(SideMenuDisplayMode value) : super(value);

  void change(SideMenuDisplayMode mode) {
    value = mode;
    notifyListeners();
  }
}

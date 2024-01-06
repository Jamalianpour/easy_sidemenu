import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_style.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';
import 'package:flutter/widgets.dart';

class Global {
  late SideMenuController controller;
  late SideMenuStyle style;
  DisplayModeNotifier displayModeState = DisplayModeNotifier(SideMenuDisplayMode.auto);
  bool showTrailing = true;
  List<Function> itemsUpdate = [];
  List items = [];
}

class DisplayModeNotifier extends ValueNotifier<SideMenuDisplayMode> {
  DisplayModeNotifier(SideMenuDisplayMode value) : super(value);

  void change(SideMenuDisplayMode mode) {
    if (value != mode) {
      value = mode;
      notifyListeners();
    }
  }
}

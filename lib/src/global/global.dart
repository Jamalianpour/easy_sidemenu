import 'package:flutter/scheduler.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_item_with_global.dart';
import 'package:easy_sidemenu/src/side_menu_style.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';
import 'package:flutter/widgets.dart';

class Global {
  late SideMenuController controller;
  late SideMenuStyle style;
  DisplayModeNotifier displayModeState =
      DisplayModeNotifier(SideMenuDisplayMode.auto);
  bool showTrailing = true;
  List<Function> itemsUpdate = [];
  List<SideMenuItemWithGlobal> items = [];
}


class DisplayModeNotifier extends ValueNotifier<SideMenuDisplayMode> {
  DisplayModeNotifier(SideMenuDisplayMode value) : super(value);

  void change(SideMenuDisplayMode mode) {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      value = mode;
      notifyListeners();
    });
  }
}
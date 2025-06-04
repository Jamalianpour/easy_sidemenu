import 'package:easy_sidemenu/src/models/side_menu_item_with_global_base.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_style.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';
import 'package:flutter/widgets.dart';

class Global extends ChangeNotifier {
  late SideMenuController controller;
  SideMenuStyle? _style;
  SideMenuStyle get style => _style!;
  set style(SideMenuStyle value) {
    _style = value;
    notifyListeners();
  }

  DisplayModeNotifier displayModeState =
      DisplayModeNotifier(SideMenuDisplayMode.auto);
  bool _showTrailing = true;
  bool get showTrailing => _showTrailing;
  set showTrailing(bool value) {
    if (_showTrailing != value) {
      _showTrailing = value;
      notifyListeners();
    }
  }

  List<SideMenuItemWithGlobalBase> _items = [];
  List<SideMenuItemWithGlobalBase> get items => _items;
  set items(List<SideMenuItemWithGlobalBase> value) {
    _items = value;
    notifyListeners();
  }

  List<bool> expansionStateList = [];
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

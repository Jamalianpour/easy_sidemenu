import 'dart:async';

import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_style.dart';
import 'package:flutter/widgets.dart';

class SideMenuController {
  late int _currentPage;

  int get currentPage => _currentPage;

  SideMenuController({int initialPage = 0}) {
    _currentPage = initialPage;
  }
  final _streamController = StreamController<int>.broadcast();

  Stream<int> get stream => _streamController.stream;

  void changePage(int index) {
    _currentPage = index;
    _streamController.sink.add(index);
  }

  void dispose() {
    _streamController.close();
  }

  void addListener(void Function(int index) listener) {
    _streamController.stream.listen(listener);
  }

  void removeListener(void Function(int) listener) {
    _streamController.stream.listen(listener).cancel();
  }
}

class Global {
  static late SideMenuController controller;
  static late SideMenuStyle style;
  static DisplayModeNotifier displayModeState =
      DisplayModeNotifier(SideMenuDisplayMode.auto);
  static bool showTrailing = true;
  static List<Function> itemsUpdate = [];
}

class DisplayModeNotifier extends ValueNotifier<SideMenuDisplayMode> {
  DisplayModeNotifier(SideMenuDisplayMode value) : super(value);

  void change(SideMenuDisplayMode mode) {
    value = mode;
    notifyListeners();
  }
}

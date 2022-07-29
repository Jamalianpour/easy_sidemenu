import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:flutter/material.dart';

class SideMenuStyle {
  /// Width of [SideMenu] when [displayMode] was SideMenuDisplayMode.open
  double? openSideMenuWidth;

  /// Width of [SideMenu] when [displayMode] was SideMenuDisplayMode.compact
  double? compactSideMenuWidth;

  /// Background color of [SideMenu]
  Color? backgroundColor;

  /// Background color of [SideMenuItem] when item is selected
  Color? selectedColor;

  /// Color of [SideMenuItem] when mouse hover on that
  Color? hoverColor;

  /// You can use the [displayMode] property to configure different
  /// display modes for the [SideMenu]
  SideMenuDisplayMode? displayMode;

  /// Style of [title] text when item is selected
  TextStyle? selectedTitleTextStyle;

  /// Style of [title] text when item is unselected
  TextStyle? unselectedTitleTextStyle;

  /// Color of icon when item is selected
  Color? selectedIconColor;

  /// Color of icon when item is unselected
  Color? unselectedIconColor;

  /// Size of icon on [SideMenuItem]
  double? iconSize;

  /// Decoration of [SideMenu] container
  BoxDecoration? decoration;

  /// Color of toggle button
  Color? toggleColor;

  /// Outer padding of menu item
  EdgeInsetsGeometry itemOuterPadding;

  /// Inner spacing of menu item
  double itemInnerSpacing;

  /// Height of menu item
  double itemHeight;

  /// Border Radius of menu item
  BorderRadius itemBorderRadius;

  /// Style class to configure [SideMenu]
  SideMenuStyle({
    this.openSideMenuWidth = 300,
    this.compactSideMenuWidth = 50,
    this.backgroundColor,
    this.selectedColor,
    this.hoverColor = Colors.transparent,
    this.displayMode = SideMenuDisplayMode.auto,
    this.selectedTitleTextStyle,
    this.unselectedTitleTextStyle,
    this.selectedIconColor = Colors.black,
    this.unselectedIconColor = Colors.black54,
    this.iconSize = 24,
    this.decoration,
    this.toggleColor = Colors.black54,
    this.itemOuterPadding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.itemInnerSpacing = 8.0,
    this.itemHeight = 50.0,
    this.itemBorderRadius = const BorderRadius.all(
      Radius.circular(5.0),
    ),
  });
}

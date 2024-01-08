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

  /// Color of [SideMenuItem] when mouse hover on that and it was selected
  Color? selectedHoverColor;

  /// You can use the [displayMode] property to configure different
  /// display modes for the [SideMenu]
  SideMenuDisplayMode? displayMode;

  /// Style of [title] text when item is selected in [SideMenuItem]
  TextStyle? selectedTitleTextStyle;

  /// Style of [title] text when item is unselected in [SideMenuItem]
  TextStyle? unselectedTitleTextStyle;

  /// Color of icon when item is selected in [SideMenuItem]
  Color? selectedIconColor;

  /// Color of icon when item is unselected in [SideMenuItem]
  Color? unselectedIconColor;

  /// Size of icon on [SideMenuItem]
  double? iconSize;
  
  /// Style of [title] text when item is selected in [SideMenuExpandableItem]
  TextStyle? selectedTitleTextStyleExpandable;

  /// Style of [title] text when item is unselected in [SideMenuExpandableItem]
  TextStyle? unselectedTitleTextStyleExpandable;

  /// Color of icon when item is selected in [SideMenuExpandableItem]
  Color? selectedIconColorExpandable;

  /// Color of icon when item is unselected in [SideMenuExpandableItem]
  Color? unselectedIconColorExpandable;

  /// Color of arrow in collapsed state in [SideMenuExpandableItem]
  Color? arrowCollapse;

  /// Color of arrow in open state in [SideMenuExpandableItem]
  Color? arrowOpen;

  /// Size of icon on [SideMenuExpandableItem]
  double? iconSizeExpandable;

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

  /// Property that will show user itemName in
  /// Tooltip when they'll hover over the item
  /// This property will only work if current
  /// [SideMenuDisplayMode] is set compact
  bool showTooltip;

  /// Property that will show Hamburger Icon on TopLeft Corner
  bool showHamburger;

  /// Style class to configure [SideMenu]
  SideMenuStyle({
    this.openSideMenuWidth = 300,
    this.compactSideMenuWidth = 70,
    this.showHamburger = false,
    this.backgroundColor,
    this.selectedColor,
    this.hoverColor = Colors.transparent,
    this.selectedHoverColor,
    this.displayMode = SideMenuDisplayMode.auto,
    this.selectedTitleTextStyle,
    this.unselectedTitleTextStyle,
    this.selectedIconColor = Colors.black,
    this.unselectedIconColor = Colors.black54,
    this.iconSize = 24,
    this.selectedTitleTextStyleExpandable,
    this.unselectedTitleTextStyleExpandable,
    this.selectedIconColorExpandable = Colors.black,
    this.unselectedIconColorExpandable = Colors.black54,
    this.iconSizeExpandable = 24,
    this.arrowOpen = Colors.black,
    this.arrowCollapse = Colors.black54,
    this.decoration,
    this.toggleColor = Colors.black54,
    this.itemOuterPadding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.itemInnerSpacing = 8.0,
    this.itemHeight = 50.0,
    this.itemBorderRadius = const BorderRadius.all(
      Radius.circular(5.0),
    ),
    this.showTooltip = true,
  });
}

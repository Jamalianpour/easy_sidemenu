import 'package:easy_sidemenu/src/side_menu_controller.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_expansion_item.dart';
import 'package:easy_sidemenu/src/side_menu_expansion_item_with_global.dart';
import 'package:easy_sidemenu/src/side_menu_hamburger_mode.dart';
import 'package:easy_sidemenu/src/side_menu_item.dart';
import 'package:easy_sidemenu/src/side_menu_item_with_global.dart';
import 'package:easy_sidemenu/src/side_menu_style.dart';
import 'package:easy_sidemenu/src/side_menu_toggle.dart';
import 'package:flutter/material.dart';

import 'global/global.dart';

class SideMenu extends StatefulWidget {
  /// Page controller to control [PageView] widget
  final SideMenuController controller;

  /// List of [SideMenuItem] or [SideMenuExpansionItem] on [SideMenu]
  final List items;

  /// List of [SideMenuItemWithGlobal] or [SideMenuExpansionItemWithGlobal] on [SideMenu]
  final SideMenuItemList sidemenuitems = SideMenuItemList();

  final Global global = Global();

  /// Title widget will shows on top of all items,
  /// it can be a logo or a Title text
  final Widget? title;

  /// Footer widget will show on bottom of [SideMenu]
  /// when [displayMode] was SideMenuDisplayMode.open
  final Widget? footer;

  /// [SideMenu] can be configured by this
  final SideMenuStyle? style;

  /// Show toggle button to switch between open and compact display mode
  /// If the display mode is auto, this button will not be displayed
  final bool? showToggle;

  /// By default footer only shown when display mode is open
  /// If you want always shown footer set it to true
  final bool? alwaysShowFooter;

  /// Notify when [SideMenuDisplayMode] changed
  final ValueChanged<SideMenuDisplayMode>? onDisplayModeChanged;

  /// Duration of [displayMode] toggling duration
  final Duration? displayModeToggleDuration;

  /// Width when will our open menu collapse into the compact one
  final int? collapseWidth;

  final double? customContentWidth;

  /// ### Easy Sidemenu widget
  ///
  /// Sidemenu is a menu that is usually located
  /// on the left or right of the page and can used for navigation
  SideMenu({
    Key? key,
    required this.items,
    required this.controller,
    this.title,
    this.footer,
    this.style,
    this.customContentWidth,
    this.showToggle = false,
    this.onDisplayModeChanged,
    this.displayModeToggleDuration,
    this.alwaysShowFooter = false,
    this.collapseWidth = 600,
  }) : super(key: key) {
    global.style = style ?? SideMenuStyle();
    global.controller = controller;
    int sideMenuExpansionItemCount = 0, sideMenuExpansionItemIndex = -1;
    for (int index = 0; index < items.length; index++) {
      if (items[index] is SideMenuExpansionItem) {
        sideMenuExpansionItemCount = sideMenuExpansionItemCount + 1;
      }
    }
    global.expansionStateList =
        List<bool>.filled(sideMenuExpansionItemCount, false);
    sidemenuitems.items = items.map((data) {
      if (data is SideMenuItem) {
        return SideMenuItemWithGlobal(
          global: global,
          title: data.title,
          onTap: data.onTap,
          icon: data.icon,
          iconWidget: data.iconWidget,
          badgeContent: data.badgeContent,
          badgeColor: data.badgeColor,
          tooltipContent: data.tooltipContent,
          trailing: data.trailing,
          builder: data.builder,
        );
      } else if (data is SideMenuExpansionItem) {
        sideMenuExpansionItemIndex = sideMenuExpansionItemIndex + 1;
        if (data.initialExpanded != null) {
          global.expansionStateList[sideMenuExpansionItemIndex] =
              data.initialExpanded!;
        }
        return SideMenuExpansionItemWithGlobal(
          global: global,
          title: data.title,
          icon: data.icon,
          index: sideMenuExpansionItemIndex,
          iconWidget: data.iconWidget,
          onTap: data.onTap,
          children: data.children
              .map((childData) => SideMenuItemWithGlobal(
                    global: global,
                    title: childData.title,
                    onTap: childData.onTap,
                    icon: childData.icon,
                    iconWidget: childData.iconWidget,
                    badgeContent: childData.badgeContent,
                    badgeColor: childData.badgeColor,
                    tooltipContent: childData.tooltipContent,
                    trailing: childData.trailing,
                    builder: childData.builder,
                  ))
              .toList(),
        );
      }
    }).toList();
    global.items = sidemenuitems.items;
  }

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  double _currentWidth = 0;
  late bool showToggle;
  late bool alwaysShowFooter;
  late int collapseWidth;
  bool animationInProgress = false;
  SideMenuHamburgerMode _hamburgerMode = SideMenuHamburgerMode.open;

  @override
  void initState() {
    super.initState();
    showToggle = widget.showToggle ?? false;
    alwaysShowFooter = widget.alwaysShowFooter ?? false;
    collapseWidth = widget.collapseWidth ?? 600;
  }

  // Updates the widget with the new `SideMenu` and sets default values for `showToggle`, `alwaysShowFooter`, and `collapseWidth`.
  // If `style` is not provided, a new `SideMenuStyle` is assigned to the `global.style`.
  // Overrides the superclass method to handle widget updates.
  @override
  void didUpdateWidget(covariant SideMenu oldWidget) {
    showToggle = widget.showToggle ?? false;
    alwaysShowFooter = widget.alwaysShowFooter ?? false;
    collapseWidth = widget.collapseWidth ?? 600;
    widget.global.style = widget.style ?? SideMenuStyle();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentWidth = _calculateWidth(
        widget.global.style.displayMode ?? SideMenuDisplayMode.auto, context);
  }

  // Toggles the state of the hamburger between open and close. No parameters. No return value.
  void _toggleHamburgerState() {
    if (_hamburgerMode == SideMenuHamburgerMode.close) {
      setState(() {
        _hamburgerMode = SideMenuHamburgerMode.open;
      });
    } else {
      setState(() {
        _hamburgerMode = SideMenuHamburgerMode.close;
      });
    }
  }

  // Notifies the parent widget if the onDisplayModeChanged callback is provided.
  void _notifyParent() {
    if (widget.onDisplayModeChanged != null) {
      widget.onDisplayModeChanged!(widget.global.displayModeState.value);
    }
  }

  // Calculate and return the appropriate width size based on the SideMenuDisplayMode and BuildContext.
  /// Set [SideMenu] width according to displayMode and notify parent widget.
  double _calculateWidth(SideMenuDisplayMode mode, BuildContext context) {
    double width = widget.global.style.openSideMenuWidth ?? 300;

    if (mode == SideMenuDisplayMode.auto) {
      width = _calculateAutoWidth(context);
    } else if (mode == SideMenuDisplayMode.open) {
      width = _calculateOpenWidth();
    } else if (mode == SideMenuDisplayMode.compact) {
      width = _calculateCompactWidth();
    }

    return width;
  }

  double _calculateAutoWidth(BuildContext context) {
    final customContentWidth =
        widget.customContentWidth ?? MediaQuery.of(context).size.width;
    if (customContentWidth > collapseWidth) {
      return _calculateOpenWidth();
    } else {
      return _calculateCompactWidth();
    }
  }

  double _calculateOpenWidth() {
    widget.global.displayModeState.change(SideMenuDisplayMode.open);
    _notifyParent();
    Future.delayed(_toggleDuration(), () {
      widget.global.showTrailing = true;
      for (var update in widget.global.itemsUpdate) {
        update();
      }
    });
    return widget.global.style.openSideMenuWidth ?? 300;
  }

  double _calculateCompactWidth() {
    widget.global.displayModeState.change(SideMenuDisplayMode.compact);
    _notifyParent();
    widget.global.showTrailing = false;
    return widget.global.style.compactSideMenuWidth ?? 50;
  }

  Decoration _decoration(SideMenuStyle? menuStyle) {
    if (menuStyle == null || menuStyle.decoration == null) {
      return BoxDecoration(
        color: widget.global.style.backgroundColor,
      );
    } else {
      if (menuStyle.backgroundColor != null) {
        menuStyle.decoration =
            menuStyle.decoration!.copyWith(color: menuStyle.backgroundColor);
      }
      return menuStyle.decoration!;
    }
  }

  Duration _toggleDuration() {
    return widget.displayModeToggleDuration ??
        const Duration(milliseconds: 350);
  }

  @override

  /// Builds the side menu widget.
  ///
  /// This method builds the side menu widget based on the provided parameters.
  /// It sets the necessary variables in the [SideMenuGlobalState], calculates the
  /// width of the side menu based on the display mode and the context, and returns
  /// the side menu widget.
  Widget build(BuildContext context) {
    // Set the variables in the SideMenuGlobalState
    widget.global.controller = widget.controller;
    widget.global.items = widget.sidemenuitems.items;

    // Create the hamburger icon button
    final IconButton hamburgerIcon = IconButton(
      icon: const Icon(IconData(0xe3dc, fontFamily: 'MaterialIcons')),
      onPressed: _toggleHamburgerState,
    );

    // Calculate the width of the side menu
    _currentWidth = _calculateWidth(
      widget.global.style.displayMode ?? SideMenuDisplayMode.auto,
      context,
    );

    // Return the side menu widget
    return ((widget.global.style.showHamburger) &&
            (_hamburgerMode == SideMenuHamburgerMode.close))
        ? Align(alignment: Alignment.topLeft, child: hamburgerIcon)
        : AnimatedContainer(
            duration: _toggleDuration(),
            width: _currentWidth,
            height: MediaQuery.sizeOf(context).height,
            decoration: _decoration(widget.style),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.global.style.showHamburger) hamburgerIcon,
                      if (widget.global.style.displayMode ==
                              SideMenuDisplayMode.compact &&
                          showToggle)
                        const SizedBox(
                          height: 42,
                        ),
                      if (widget.title != null) widget.title!,
                      ...widget.sidemenuitems.items,
                    ],
                  ),
                ),
                if ((widget.footer != null &&
                        widget.global.displayModeState.value !=
                            SideMenuDisplayMode.compact) ||
                    (widget.footer != null && alwaysShowFooter))
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.footer!,
                  ),
                if (widget.global.style.displayMode !=
                        SideMenuDisplayMode.auto &&
                    showToggle)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.global.displayModeState.value ==
                              SideMenuDisplayMode.open
                          ? 0
                          : 4,
                      vertical: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SideMenuToggle(
                          global: widget.global,
                          onTap: () {
                            if (context
                                    .findAncestorStateOfType<_SideMenuState>()
                                    ?.animationInProgress ??
                                false) {
                              return;
                            }
                            if (widget.global.displayModeState.value ==
                                SideMenuDisplayMode.compact) {
                              setState(() {
                                widget.global.style.displayMode =
                                    SideMenuDisplayMode.open;
                              });
                            } else if (widget.global.displayModeState.value ==
                                SideMenuDisplayMode.open) {
                              setState(() {
                                widget.global.style.displayMode =
                                    SideMenuDisplayMode.compact;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      widget.global.displayModeState
          .change(widget.global.displayModeState.value);
    });
    super.dispose();
  }
}

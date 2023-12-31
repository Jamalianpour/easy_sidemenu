import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_item.dart';
import 'package:easy_sidemenu/src/side_menu_style.dart';
import 'package:easy_sidemenu/src/side_menu_toggle.dart';
import 'package:easy_sidemenu/src/side_menu_item_with_global.dart';
import 'package:easy_sidemenu/src/side_menu_expansion_item.dart';
import 'package:easy_sidemenu/src/side_menu_expansion_item_with_global.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';
import 'package:flutter/material.dart';
import 'global/global.dart';

class SideMenu extends StatefulWidget {
  /// Page controller to control [PageView] widget
  final SideMenuController controller;

  /// List of [SideMenuItem] on [SideMenu]
  final List items;

  /// List of [SideMenuItemWithGlobal] or [SideMenuExpansionItemWithGlobal] on [SideMenu]
  List sidemenuitems = [];

  Global global = Global();

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
    this.showToggle = false,
    this.onDisplayModeChanged,
    this.displayModeToggleDuration,
    this.alwaysShowFooter = false,
    this.collapseWidth = 600,
  }) : super(key: key) {
    this.global.style = this.style ?? SideMenuStyle();
    this.global.controller = this.controller;
    sidemenuitems = items.map((data) {
      if (data is SideMenuItem) {
        return SideMenuItemWithGlobal(
          global: this.global,
          title: data.title ?? null,
          onTap: data.onTap ?? null,
          icon: data.icon ?? null,
          iconWidget: data.iconWidget ?? null,
          badgeContent: data.badgeContent ?? null,
          badgeColor: data.badgeColor ?? null,
          tooltipContent: data.tooltipContent ?? null,
          trailing: data.trailing ?? null,
          builder: data.builder ?? null,
        );
      } else if (data is SideMenuExpansionItem) {
        return SideMenuExpansionItemWithGlobal(
          global: this.global,
          children: data.children ?? [],
          title: data.title ?? null,
          icon: data.icon ?? null,
          iconWidget: data.iconWidget ?? null,
        );
      }
    }).toList();
    this.global.items = this.sidemenuitems;
  }

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // late Global global;
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
    _currentWidth = _widthSize(
        widget.global.style.displayMode ?? SideMenuDisplayMode.auto, context);
  }

  void _toggleHamburgerState() {
    if (this._hamburgerMode == SideMenuHamburgerMode.close) {
      setState(() {
        this._hamburgerMode = SideMenuHamburgerMode.open;
      });
    } else {
      setState(() {
        this._hamburgerMode = SideMenuHamburgerMode.close;
      });
    }
  }

  void _notifyParent() {
    if (widget.onDisplayModeChanged != null) {
      widget.onDisplayModeChanged!(widget.global.displayModeState.value);
    }
  }

  /// Set [SideMenu] width according to displayMode and notify parent widget
  double _widthSize(SideMenuDisplayMode mode, BuildContext context) {
    animationInProgress = true;
    if (mode == SideMenuDisplayMode.auto) {
      if (MediaQuery.of(context).size.width > collapseWidth) {
        if (widget.global.displayModeState.value != SideMenuDisplayMode.open) {
          widget.global.displayModeState.change(SideMenuDisplayMode.open);
          _notifyParent();
          Future.delayed(_toggleDuration(), () {
            widget.global.showTrailing = true;
            for (var update in widget.global.itemsUpdate) {
              update();
            }
            animationInProgress = false;
          });
        }
        return widget.global.style.openSideMenuWidth ?? 300;
      } else if (MediaQuery.sizeOf(context).width <= collapseWidth) {
        if (widget.global.displayModeState.value !=
            SideMenuDisplayMode.compact) {
          widget.global.displayModeState.change(SideMenuDisplayMode.compact);
          _notifyParent();
          widget.global.showTrailing = false;
        }

        return widget.global.style.compactSideMenuWidth ?? 50;
      }
      return _currentWidth;
    } else if (mode == SideMenuDisplayMode.open) {
      if (widget.global.displayModeState.value != SideMenuDisplayMode.open) {
        widget.global.displayModeState.change(SideMenuDisplayMode.open);
        _notifyParent();
        Future.delayed(_toggleDuration(), () {
          widget.global.showTrailing = true;
          for (var update in widget.global.itemsUpdate) {
            update();
          }
          animationInProgress = false;
        });
      }
      return widget.global.style.openSideMenuWidth ?? 300;
    } else if (mode == SideMenuDisplayMode.compact) {
      if (widget.global.displayModeState.value != SideMenuDisplayMode.compact) {
        widget.global.displayModeState.change(SideMenuDisplayMode.compact);
        _notifyParent();
        widget.global.showTrailing = false;
      }

      return widget.global.style.compactSideMenuWidth ?? 50;
    }

    return _currentWidth;
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
  Widget build(BuildContext context) {
    widget.global.controller = widget.controller;
    widget.global.items = widget.sidemenuitems;
    IconButton hamburgerIcon = IconButton(
        icon: Icon(IconData(0xe3dc, fontFamily: 'MaterialIcons')),
        onPressed: _toggleHamburgerState);
    _currentWidth = _widthSize(
        widget.global.style.displayMode ?? SideMenuDisplayMode.auto, context);
    return (_hamburgerMode == SideMenuHamburgerMode.close)
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
                      hamburgerIcon,
                      if (widget.global.style.displayMode ==
                              SideMenuDisplayMode.compact &&
                          showToggle)
                        const SizedBox(
                          height: 42,
                        ),
                      if (widget.title != null) widget.title!,
                      ...widget.sidemenuitems,
                    ],
                  ),
                ),
                if ((widget.footer != null &&
                        widget.global.displayModeState.value !=
                            SideMenuDisplayMode.compact) ||
                    (widget.footer != null && alwaysShowFooter))
                  Align(
                      alignment: Alignment.bottomCenter, child: widget.footer!),
                if (widget.global.style.displayMode !=
                        SideMenuDisplayMode.auto &&
                    showToggle)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.global.displayModeState.value ==
                                SideMenuDisplayMode.open
                            ? 0
                            : 4,
                        vertical: 0),
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

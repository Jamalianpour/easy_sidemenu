import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'global/global.dart';

class SideMenuFolder extends StatefulWidget {
  /// #### Side Menu Item
  ///
  /// This is a widget as [SideMenu] items with text and icon
  const SideMenuFolder(
      {Key? key,
      this.title,
      this.icon,
      this.iconWidget,
      required this.priority,
      required this.children,
      this.builder})
      : assert(title != null || icon != null,
            'Title and icon should not be empty at the same time'),
        super(key: key);

  /// Fold name
  final String? title;

  /// A Icon to display before [title]
  final Icon? icon;

  /// This is displayed instead if [icon] is null
  final Widget? iconWidget;

  /// Priority of item to show on [SideMenu], lower value is displayed at the top
  ///
  /// * Start from 0
  /// * This value should be unique
  /// * This value used for page controller index
  final int priority;

  final List<SideMenuItem> children;

  /// Create custom sideMenuItem widget with builder
  ///
  /// Builder has `(BuildContext context, SideMenuDisplayMode displayMode)`
  final SideMenuItemBuilder? builder;

  @override
  _SideMenuFolderState createState() => _SideMenuFolderState();
}

class _SideMenuFolderState extends State<SideMenuFolder> {
  late int currentPage = Global.controller.currentPage;
  bool isHovered = false;

  /// Set icon for of [SideMenuFolder]
  Widget _generateIcon(Icon? mainIcon, Widget? iconWidget) {
    if (mainIcon == null) return iconWidget ?? const SizedBox();
    Icon icon = Icon(
      mainIcon.icon,
      /*color: widget.priority == currentPage
          ? Global.style.selectedIconColor ?? Colors.black
          : Global.style.unselectedIconColor ?? Colors.black54,*/
      size: Global.style.iconSize ?? 24,
    );

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    widget.children.sort((a, b) => a.priority.compareTo(b.priority));
    return ValueListenableBuilder(
        valueListenable: Global.displayModeState,
        builder: (context, value, child) {
          return ListTileTheme(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: value == SideMenuDisplayMode.compact
                      ? Global.style.itemInnerSpacing
                      : Global.style.itemInnerSpacing + 5),
              horizontalTitleGap: 0,
              child: ExpansionTile(
                  //trailing:  (value==SideMenuDisplayMode.open)?null:const SizedBox.shrink(),

                  leading: _generateIcon(widget.icon, widget.iconWidget),
                  //leading: (value==SideMenuDisplayMode.open)?Container():widget.icon,
                  title: (value == SideMenuDisplayMode.open)
                      ? Text(
                          widget.title ?? '',
                        )
                      : Container(),
                  children: widget.children.map((item) {
                    item.isIndented=true;
                    return item;
                  }).toList()));
        });
  }
}

import 'package:flutter/material.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_item_with_global.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';

import 'global/global.dart';

class SideMenuExpansionItemWithGlobal extends StatefulWidget {
  /// #### Side Menu Item
  ///
  /// This is a widget as [SideMenu] items with text and icon
  /// Fold name
  final String? title;

  /// Global object of [SideMenu]
  final Global global;

  /// A Icon to display before [title]
  final Icon? icon;

  /// This is displayed instead if [icon] is null
  final Widget? iconWidget;

  /// The Children widgets
  final List<SideMenuItemWithGlobal> children;

  /// for maintaining record of the state
  final int index;

  /// A function that will be called when tap on [SideMenuExpansionItem] corresponding
  /// to this [SideMenuExpansionItem]
  final void Function(int index, SideMenuController sideMenuController, bool isExpanded)? onTap;

  const SideMenuExpansionItemWithGlobal(
      {Key? key,
      required this.global,
      this.title,
      this.icon,
      this.iconWidget,
      this.onTap,
      required this.index,
      required this.children})
      : assert(title != null || icon != null,
            'Title and icon should not be empty at the same time'),
        super(key: key);

  @override
  State<SideMenuExpansionItemWithGlobal> createState() =>
      _SideMenuExpansionState();
}

class _SideMenuExpansionState extends State<SideMenuExpansionItemWithGlobal> {
  /// Set icon for of [SideMenuExpansionItemWithGlobal]
  late bool isExpanded;
  @override
  void initState() {
    super.initState();
    isExpanded = widget.global.expansionStateList[widget.index];
  }

  // Generates an icon widget based on the main icon and icon widget provided. 
  // If the main icon is null, returns the icon widget or a SizedBox if no icon widget is provided. 
  // Determines the icon color and size based on the expansion state and global styling. 
  // Returns an Icon widget with the specified icon, color, and size.
  Widget _generateIconWidget(Icon? mainIcon, Widget? iconWidget) {
    if (mainIcon == null) return iconWidget ?? const SizedBox();

    final bool isExpanded = widget.global.expansionStateList[widget.index];
    final Color iconColor = isExpanded
        ? widget.global.style.selectedIconColorExpandable ??
            widget.global.style.selectedColor ??
            Colors.black
        : widget.global.style.unselectedIconColorExpandable ??
            widget.global.style.unselectedIconColor ??
            Colors.black54;
    final double iconSize = widget.global.style.iconSizeExpandable ??
        widget.global.style.iconSize ??
        24;

    return Icon(mainIcon.icon, color: iconColor, size: iconSize);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.global.displayModeState,
      builder: (context, value, child) {
        return ListTileTheme(
          contentPadding: EdgeInsets.symmetric(
            horizontal: value == SideMenuDisplayMode.compact
                ? widget.global.style.itemInnerSpacing
                : widget.global.style.itemInnerSpacing + 5,
          ),
          horizontalTitleGap: 0,
          child: ExpansionTile(
              leading: SizedBox(
                // Ensures the icon does not take the full tile width
                width: 40.0, // Adjust size constraints as required
                child: _generateIconWidget(widget.icon, widget.iconWidget),
              ),
              // The title should only take space when SideMenuDisplayMode is open
              maintainState: true,
              onExpansionChanged: (value) {
                setState(() {
                  isExpanded = value;
                  widget.global.expansionStateList[widget.index] = value;
                });
                widget.onTap?.call(widget.index, widget.global.controller, value);
              },
              trailing: Icon(
                isExpanded
                    ? Icons.arrow_drop_down_circle
                    : Icons.arrow_drop_down,
                color: isExpanded
                    ? widget.global.style.arrowOpen
                    : widget.global.style.arrowCollapse,
              ),
              initiallyExpanded: widget.global.expansionStateList[widget.index],
              title: (value == SideMenuDisplayMode.open)
                  ? Text(
                      widget.title ?? '',
                      style: widget.global.expansionStateList[widget.index]
                          ? const TextStyle(fontSize: 17, color: Colors.black)
                              .merge(widget.global.style
                                      .selectedTitleTextStyleExpandable ??
                                  widget.global.style.selectedTitleTextStyle)
                          : const TextStyle(fontSize: 17, color: Colors.black54)
                              .merge(widget.global.style
                                      .unselectedTitleTextStyleExpandable ??
                                  widget.global.style.unselectedTitleTextStyle),
                    )
                  : const Text(''),
              children: widget.children),
        );
      },
    );
  }
}

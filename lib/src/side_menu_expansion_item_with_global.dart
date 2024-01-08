import 'package:flutter/material.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_item_with_global.dart';

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

  const SideMenuExpansionItemWithGlobal(
      {Key? key,
      required this.global,
      this.title,
      this.icon,
      this.iconWidget,
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

  Widget _generateIcon(Icon? mainIcon, Widget? iconWidget) {
    if (mainIcon == null) return iconWidget ?? const SizedBox();
    Icon icon = Icon(
      mainIcon.icon,
      color: (widget.global.expansionStateList[widget.index]) // If value is true then the Expandable Item is fully expanded, else it is collapsed
          ? widget.global.style.selectedColor ?? Colors.black
          : widget.global.style.unselectedIconColor ?? Colors.black54,
      size: widget.global.style.iconSize ?? 24,
    );
    return icon;
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
                child: _generateIcon(widget.icon, widget.iconWidget),
              ),
              // The title should only take space when SideMenuDisplayMode is open
              maintainState: true,
              onExpansionChanged: (value) {
                setState(() {
                  isExpanded = value;
                  widget.global.expansionStateList[widget.index] = value;
                });
              },
              initiallyExpanded: widget.global.expansionStateList[widget.index],
              title: (value == SideMenuDisplayMode.open)
                  ? Text(
                      widget.title ?? '',
                    )
                  : const Text(''),
              children: widget.children),
        );
      },
    );
  }
}

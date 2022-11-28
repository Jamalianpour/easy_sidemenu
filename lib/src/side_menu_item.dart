import 'package:badges/badges.dart';
import 'package:easy_sidemenu/src/side_menu_folder.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';

import 'global/global.dart';

typedef SideMenuItemBuilder = Widget Function(
    BuildContext context, SideMenuDisplayMode displayMode);

class SideMenuItem extends StatefulWidget {
  /// #### Side Menu Item
  ///
  /// This is a widget as [SideMenu] items with text and icon
  const SideMenuItem({
    Key? key,
    this.folder,
    this.onTap,
    this.title,
    this.icon,
    this.iconWidget,
    required this.priority,
    this.badgeContent,
    this.badgeColor,
    this.tooltipContent,
    this.trailing,
    this.builder,
  })  : assert(title != null || icon != null,
            'Title and icon should not be empty at the same time'),
        super(key: key);

  /// Fold name
  final SideMenuFolder? folder;

  /// A function that call when tap on [SideMenuItem]
  final void Function(int, SideMenuController)? onTap;

  /// Title text
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

  /// Text show next to the icon as badge
  /// By default this is null
  final Widget? badgeContent;

  /// Background color for badge
  final Color? badgeColor;

  /// Content of the tooltip - if not filled, the [title] will
  /// be used. [showTooltipOverItemsName] must be set to true.
  final String? tooltipContent;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] widget.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [CrossAxisAlignment.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget? trailing;

  /// Create custom sideMenuItem widget with builder
  ///
  /// Builder has `(BuildContext context, SideMenuDisplayMode displayMode)`
  final SideMenuItemBuilder? builder;

  @override
  _SideMenuItemState createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItem> {
  late int currentPage = Global.controller.currentPage;
  bool isHovered = false;

  void _handleChange(int page) {
    if (mounted) {
      setState(() {
        currentPage = page;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nonNullableWrap(WidgetsBinding.instance)!
        .addPostFrameCallback((timeStamp) {
      // set initialPage
      setState(() {
        currentPage = Global.controller.currentPage;
      });
      if (mounted) {
        // set controller SideMenuItem page controller callback
        Global.controller.addListener(_handleChange);
      }
    });
    Global.itemsUpdate.add(update);
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    Global.controller.removeListener(_handleChange);
    super.dispose();
  }

  /// This allows a value of type T or T?
  /// to be treated as a value of type T?.
  ///
  /// We use this so that APIs that have become
  /// non-nullable can still be used with `!` and `?`
  /// to support older versions of the API as well.
  /// https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.0.0#your-code
  T? _nonNullableWrap<T>(T? value) => value;

  /// Set background color of [SideMenuItem]
  Color _setColor() {
    if (widget.priority == currentPage) {
      return Global.style.selectedColor ?? Theme.of(context).highlightColor;
    } else if (isHovered) {
      return Global.style.hoverColor ?? Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }

  /// Set icon for of [SideMenuItem]
  Widget _generateIcon(Icon? mainIcon, Widget? iconWidget) {
    if (mainIcon == null) return iconWidget ?? const SizedBox();
    Icon icon = Icon(
      mainIcon.icon,
      color: widget.priority == currentPage
          ? Global.style.selectedIconColor ?? Colors.black
          : Global.style.unselectedIconColor ?? Colors.black54,
      size: Global.style.iconSize ?? 24,
    );
    if (widget.badgeContent == null) {
      return icon;
    } else {
      return Badge(
        badgeContent: widget.badgeContent!,
        badgeColor: widget.badgeColor ?? Colors.red,
        alignment: Alignment.bottomRight,
        position: const BadgePosition(top: -13, end: -7),
        child: icon,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: Global.style.itemOuterPadding,
        child: Container(
          height: Global.style.itemHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _setColor(),
            borderRadius: Global.style.itemBorderRadius,
          ),
          child: ValueListenableBuilder(
            valueListenable: Global.displayModeState,
            builder: (context, value, child) {
              if (widget.builder == null) {
                return Tooltip(
                  message: (value == SideMenuDisplayMode.compact &&
                          Global.style.showTooltip)
                      ? widget.tooltipContent ?? widget.title ?? ""
                      : "",
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: value == SideMenuDisplayMode.compact ? 0 : 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Global.style.itemInnerSpacing,
                        ),
                        _generateIcon(widget.icon, widget.iconWidget),
                        SizedBox(
                          width: Global.style.itemInnerSpacing,
                        ),
                        if (value == SideMenuDisplayMode.open) ...[
                          Expanded(
                            child: Text(
                              widget.title ?? '',
                              style: widget.priority == currentPage.ceil()
                                  ? const TextStyle(
                                          fontSize: 17, color: Colors.black)
                                      .merge(
                                          Global.style.selectedTitleTextStyle)
                                  : const TextStyle(
                                          fontSize: 17, color: Colors.black54)
                                      .merge(Global
                                          .style.unselectedTitleTextStyle),
                            ),
                          ),
                          if (widget.trailing != null &&
                              Global.showTrailing) ...[
                            widget.trailing!,
                            SizedBox(
                              width: Global.style.itemInnerSpacing,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                );
              } else {
                return widget.builder!(context, value as SideMenuDisplayMode);
              }
            },
          ),
        ),
      ),
      onTap: () => widget.onTap?.call(widget.priority, Global.controller),
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}

// import 'package:badges/badges.dart' as bdg;
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'global/global.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';

typedef SideMenuItemBuilder = Widget Function(
    BuildContext context, SideMenuDisplayMode displayMode);

class SideMenuItemList {
  late List<dynamic> items;
}

class SideMenuItemWithGlobal extends StatefulWidget {
  /// #### Side Menu Item
  ///
  /// This is a widget as [SideMenu] items with text and icon
  const SideMenuItemWithGlobal({
    Key? key,
    required this.global,
    this.onTap,
    this.title,
    this.titleFlex = 1,
    this.icon,
    this.iconWidget,
    this.badgeContent,
    this.badgeColor,
    this.tooltipContent,
    this.trailing,
    this.builder,
  })  : assert(title != null || icon != null || builder != null,
            'Title, icon and builder should not be empty at the same time'),
        super(key: key);

  /// A function that call when tap on [SideMenuItemWithGlobal]
  final void Function(int index, SideMenuController sideMenuController)? onTap;

  /// Global object of [SideMenu]
  final Global global;

  /// Title text
  final String? title;

  /// Title flex for expanding
  final int titleFlex;

  /// A Icon to display before [title]
  final Icon? icon;

  /// This is displayed instead if [icon] is null
  final Widget? iconWidget;

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
  State<SideMenuItemWithGlobal> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItemWithGlobal> {
  late int currentPage = widget.global.controller.currentPage;
  bool isHovered = false;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    _nonNullableWrap(WidgetsBinding.instance)!
        .addPostFrameCallback((timeStamp) {
      // Set initialPage, only if the widget is still mounted
      if (mounted) {
        currentPage = widget.global.controller.currentPage;
      }
      if (!isDisposed) {
        // Set controller SideMenuItem page controller callback
        widget.global.controller.addListener(_handleChange);
      }
    });
    widget.global.itemsUpdate.add(update);
  }

  void update() {
    if (mounted) {
      // Trigger a build only if the widget is still mounted
      setState(() {});
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    widget.global.controller.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange(int page) {
    safeSetState(() {
      currentPage = page;
    });
  }

  /// Ensure that safeSetState only calls setState when the widget is still mounted.
  ///
  /// When adding changes to this library in future, use this function instead of
  /// if (mounted) condition on setState at every place
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  bool isSameWidget(SideMenuItemWithGlobal other) {
    if (other.icon == widget.icon &&
        other.title == widget.title &&
        other.builder == widget.builder &&
        other.trailing == widget.trailing) {
      return true;
    } else {
      return false;
    }
  }

  /// This allows a value of type T or T?
  /// to be treated as a value of type T?.
  ///
  /// We use this so that APIs that have become
  /// non-nullable can still be used with `!` and `?`
  /// to support older versions of the API as well.
  /// https://docs.flutter.dev/development/tools/sdk/release-notes/release-notes-3.0.0#your-code
  T? _nonNullableWrap<T>(T? value) => value;

  int _getIndexOfCurrentSideMenuItemWidget() {
    int index = 0;
    int n = widget.global.items.length;
    for (int i = 0; i < n; i++) {
      if (widget.global.items[i] is SideMenuItemWithGlobal) {
        if (isSameWidget(widget.global.items[i])) {
          return index;
        } else {
          index = index + 1;
        }
      } else {
        int m = widget.global.items[i].children.length;
        for (int j = 0; j < m; j++) {
          if (isSameWidget(widget.global.items[i].children[j])) {
            return index;
          } else {
            index = index + 1;
          }
        }
      }
    }
    return -1;
  }

  /// Set background color of [SideMenuItemWithGlobal]
  Color _setColor() {
    if (_getIndexOfCurrentSideMenuItemWidget() == currentPage) {
      if (isHovered) {
        return widget.global.style.selectedHoverColor ??
            widget.global.style.selectedColor ??
            Theme.of(context).highlightColor;
      } else {
        return widget.global.style.selectedColor ??
            Theme.of(context).highlightColor;
      }
    } else if (isHovered) {
      return widget.global.style.hoverColor ?? Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }

  // Generates an icon based on the mainIcon and iconWidget provided. If mainIcon is null, it returns iconWidget or a SizedBox if iconWidget is also null.
  // Determines the color and size of the icon based on the current selection state. If a badgeContent is provided,
  // wraps the icon with a Badge widget using the badgeContent, badgeColor, and position specified.
  Widget _generateIcon(Icon? mainIcon, Widget? iconWidget) {
    if (mainIcon == null) return iconWidget ?? const SizedBox();
    final Color iconColor = _isCurrentSideMenuItemSelected()
        ? widget.global.style.selectedIconColor ?? Colors.black
        : widget.global.style.unselectedIconColor ?? Colors.black54;
    final double iconSize = widget.global.style.iconSize ?? 24;

    final Icon icon = Icon(
      mainIcon.icon,
      color: iconColor,
      size: iconSize,
    );

    return widget.badgeContent == null
        ? icon
        : Badge(
            label: widget.badgeContent!,
            backgroundColor: widget.badgeColor ?? Colors.red,
            offset: const Offset(-13, -7),
            alignment: Alignment.topRight,
            child: icon,
          );
  }

  bool _isCurrentSideMenuItemSelected() {
    return _getIndexOfCurrentSideMenuItemWidget() == currentPage;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder == null) {
      return InkWell(
        onTap: () => widget.onTap?.call(
            _getIndexOfCurrentSideMenuItemWidget(), widget.global.controller),
        onHover: (value) {
          safeSetState(() {
            isHovered = value;
          });
        },
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Padding(
          padding: widget.global.style.itemOuterPadding,
          child: Container(
            height: widget.global.style.itemHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _setColor(),
              borderRadius: widget.global.style.itemBorderRadius,
            ),
            child: ValueListenableBuilder(
              valueListenable: widget.global.displayModeState,
              builder: (context, value, child) {
                return Tooltip(
                  message: (value == SideMenuDisplayMode.compact &&
                          widget.global.style.showTooltip)
                      ? widget.tooltipContent ?? widget.title ?? ""
                      : "",
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: value == SideMenuDisplayMode.compact
                            ? widget.global.style.itemInnerSpacing
                            : widget.global.style.itemInnerSpacing),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: widget.global.style.itemInnerSpacing * 2),
                        _generateIcon(widget.icon, widget.iconWidget),
                        SizedBox(width: widget.global.style.itemInnerSpacing),
                        if (value == SideMenuDisplayMode.open) ...[
                          Expanded(
                            flex: widget.titleFlex,
                            // Expanded will allow the text to take up all available space
                            child: Text(
                              widget.title ?? '',
                              overflow: TextOverflow
                                  .ellipsis, // Helps to handle long text
                              style: _getIndexOfCurrentSideMenuItemWidget() ==
                                      currentPage.ceil()
                                  ? const TextStyle(
                                          fontSize: 17, color: Colors.black)
                                      .merge(widget
                                          .global.style.selectedTitleTextStyle)
                                  : const TextStyle(
                                          fontSize: 17, color: Colors.black54)
                                      .merge(widget.global.style
                                          .unselectedTitleTextStyle),
                            ),
                          ),
                          // const SizedBox.shrink(),
                          if (widget.trailing != null &&
                              widget.global.showTrailing) ...[
                            // Aligning the trailing widget to the right
                            widget.trailing!,
                          ],
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    } else {
      return ValueListenableBuilder(
        valueListenable: widget.global.displayModeState,
        builder: (context, value, child) {
          return widget.builder!(context, value as SideMenuDisplayMode);
        },
      );
    }
  }
}

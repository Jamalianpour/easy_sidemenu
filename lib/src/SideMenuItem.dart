import 'SideMenuDisplayMode.dart';
import 'Global/Global.dart';
import 'package:flutter/material.dart';

class SideMenuItem extends StatefulWidget {
  /// #### Side Menu Item
  ///
  /// This is a widget as [SideMenu] items with text and icon
  const SideMenuItem({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icon,
    required this.priority,
  }) : super(key: key);

  /// A function that call when tap on [SideMenuItem]
  final Function onTap;

  /// Title text
  final String title;

  /// A Icon to display before [title]
  final IconData icon;

  /// Priority of item to show on [SideMenu], lower value is displayed at the top
  ///
  /// * Start from 0
  /// * This value should be unique
  /// * This value used for page controller index
  final int priority;

  @override
  _SideMenuItemState createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<SideMenuItem> {
  double curentPage = 0;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    Global.controller.addListener(() {
      setState(() {
        curentPage = Global.controller.page!;
      });
    });
  }

  /// Set background color of [SideMenuItem]
  Color _setColor() {
    if (widget.priority == curentPage) {
      return Global.style.selectedColor ?? Theme.of(context).highlightColor;
    } else if (isHovered) {
      return Global.style.hoverColor ?? Colors.transparent;
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _setColor(),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: ValueListenableBuilder(
            valueListenable: Global.displayModeState,
            builder: (context, value, child) {
              return Padding(
                padding: value == SideMenuDisplayMode.compact
                    ? EdgeInsets.only(left: 8.0)
                    : EdgeInsets.only(left: 8.0, bottom: 8, top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.priority == curentPage
                          ? Global.style.selectedIconColor ?? Colors.black
                          : Global.style.unselectedIconColor ?? Colors.black54,
                      size: Global.style.iconSize ?? 24,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    if (value == SideMenuDisplayMode.open)
                      Expanded(
                        child: Text(
                          widget.title,
                          style: widget.priority == curentPage
                              ? TextStyle(fontSize: 17, color: Colors.black)
                                  .merge(Global.style.selectedTitleTextStyle)
                              : TextStyle(fontSize: 17, color: Colors.black54)
                                  .merge(Global.style.unselectedTitleTextStyle),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      onTap: () => widget.onTap(),
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

import 'package:badges/badges.dart' as bdg;
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/src/side_menu_display_mode.dart';
import 'package:easy_sidemenu/src/side_menu_controller.dart';

class SideMenuItem {
  /// Title text
  final String? title;

  /// A function that will be called when tap on [SideMenuItem] corresponding 
  /// to this [SideMenuItem]
  final void Function(int index, SideMenuController sideMenuController)? onTap;

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
  final Widget Function(BuildContext context, SideMenuDisplayMode displayMode)? builder;

  const SideMenuItem({
    this.onTap,
    this.title,
    this.icon,
    this.iconWidget,
    this.badgeContent,
    this.badgeColor,
    this.tooltipContent,
    this.trailing,
    this.builder,
  })  : assert(title != null || icon != null || builder != null,
            'Title, icon and builder should not be empty at the same time'),
        super();
    
}
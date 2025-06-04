## [0.7.0]
* Refactored the `Global` class to extend `ChangeNotifier`.
* Optimized Width Calculation
* Removed `itemsUpdate` Mechanism
* `SideMenuItemType` as a base interface for `SideMenuItem` and `SideMenuExpansionItem`.

## [0.6.1]
* **New Features**
  * add onTap event -> `SideMenuExpansionItem` [#85](https://github.com/Jamalianpour/easy_sidemenu/pull/85)

* Removed `Badge` dependencies and use Flutter builtin `Badge`
* Fix RTL issues

## [0.6.0]
* **New Features** 
  * Add expansion item -> `SideMenuExpansionItem`
  * Add Hamburger Icon [#77](https://github.com/Jamalianpour/easy_sidemenu/pull/77)

* Fix: width not being returned on 2nd load [#61](https://github.com/Jamalianpour/easy_sidemenu/pull/61)
* Refactor codes

## [0.5.0]
* **Braking**: priority has been removed from `SideMenuItem`
* builder has been changed and now can use any widget as `SideMenuItem`
* Fix some performance issue

## [0.4.2]
* Fix issue [#46](https://github.com/Jamalianpour/easy_sidemenu/issues/46): the width is not properly calculated when the widget is drawn a second time - [#58](https://github.com/Jamalianpour/easy_sidemenu/pull/58)
* Fix error on builder - [#39](https://github.com/Jamalianpour/easy_sidemenu/issues/39)
* Update readme

## [0.4.1+1]
* Fix Badge error on flutter 3.7.0

## [0.4.1]
* Custom builder available for `SideMenuItem`
* Fix SideMenu dispose - [#29](https://github.com/Jamalianpour/easy_sidemenu/issues/29)

## [0.4.0]
* Custom collapse breakpoint feature  - [#17](https://github.com/Jamalianpour/easy_sidemenu/pull/17)
* Add tooltip to `SideMenuItem` - [#20](https://github.com/Jamalianpour/easy_sidemenu/pull/20)
* Change `SideMenuItem` title to optional - [#24](https://github.com/Jamalianpour/easy_sidemenu/pull/24)
* Fix issue SideMenu doesn't show when navigation back and forth - [#27](https://github.com/Jamalianpour/easy_sidemenu/pull/27)
* Add trailing widget to `SideMenuItem`

## [0.3.2]
* Fix delete menu from widget tree - [#15](https://github.com/Jamalianpour/easy_sidemenu/pull/15)
* Add alwaysShowFooter

## [0.3.1]
* Fix null exception on `onDisplayModeChanged`
* Fix `WidgetsBinding.instance` null checker in flutter 3

## [0.3.0]
* Add listener to `SideMenuDisplayMode` changed
* Add toggle button to open and compact sidemenu
* Refactor code by [myConsciousness](https://github.com/myConsciousness) - [#8](https://github.com/Jamalianpour/easy_sidemenu/pull/8)

## [0.2.1]
* Support RTL languages
* Add `decoration` to `SideMenuStyle`
* Fix initialPage bug

## [0.2.0]
* Add badge support to the sidemenu
* Change IconData to Icon for more flexibility

## [0.1.1+1]
* Add demo to readme

## [0.1.1]
* Add readme to package

## [0.1.0] 
* First release
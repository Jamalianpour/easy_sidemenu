<div align="center" style="text-align:center">
<h1 align="center">Easy Sidemenu</h1>
<img align="center" src="https://raw.githubusercontent.com/Jamalianpour/easy_sidemenu/master/images/logo.png" alt="logo" height=170/>
</br>
<a href="https://github.com/Jamalianpour/easy_sidemenu/license">
    <img alt="GitHub" src="https://img.shields.io/github/license/Jamalianpour/easy_sidemenu">
</a>
<a href="https://pub.dev/packages/easy_sidemenu">
   <img alt="Pub Version" src="https://img.shields.io/pub/v/easy_sidemenu.svg?longCache=true" />   
</a>
<a>
    <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/Jamalianpour/easy_sidemenu">
</a>
</div>

Easy sidemenu is An easy to use side menu (bar) for flutter that you can use for navigation in your application.

Sidemenu is a menu that is usually located on the left or right of the page and can used for navigation or other things.
Sidemenu is similar to bottom navigation bar but in the side of screen and usually used for larger screens.

## Screenshots

| Open                             | Compact                             |
| -------------------------------- | ----------------------------------- |
| ![Open](images/Screenshot_1.jpeg) | ![Compact](images/Screenshot_2.jpeg) |

| Auto                              |
| --------------------------------- |
| ![Auto](images/easy_sidemenu.gif) |

## Demo

You can see web demo here: [https://jamalianpour.github.io/easy_sidemenu](https://jamalianpour.github.io/easy_sidemenu)

## Usage

##### 1. add dependencies into you project pubspec.yaml file

```yaml
dependencies:
  easy_sidemenu: ^0.6.1
```

Run `flutter packages get` in the root directory of your app.

##### 2. import easy sidemenu lib

```dart
import 'package:easy_sidemenu/easy_sidemenu.dart';
```

Now you can use `SideMenu` as a widget in your code.

##### 3. use SideMenu

You must first define a list of items to display on `SideMenu`:

```dart
List items = [
  SideMenuItem(
    title: 'Dashboard',
    onTap: (index, _) {
      sideMenu.changePage(index);
    },
    icon: Icon(Icons.home),
    badgeContent: Text(
      '3',
      style: TextStyle(color: Colors.white),
    ),
  ),
  SideMenuExpansionItem(
    title: "Expansion Item",
    icon: const Icon(Icons.kitchen),
    onTap: (index, _, isExpanded) => {
        print('$index, expanded $isExpanded')
    },
    children: [
      SideMenuItem(
        title: 'Expansion Item 1',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.home),
      ),
      SideMenuItem(
        title: 'Expansion Item 2',
        onTap: (index, _) {
          sideMenu.changePage(index);
        },
        icon: const Icon(Icons.supervisor_account),
      )
    ],
  ),
  SideMenuItem(
    title: 'Exit',
    onTap: () {},
    icon: Icon(Icons.exit_to_app),
  ),
];
```

###### custom builder:

Instead of `title` and `icon` in `SideMenuItem` can use `builder` to create your customize items:

```dart
SideMenuItem(
  builder: (context, displayMode) {
    return Container();
  },
  onTap: () {},
),
```

After that you need to warp your main page to a `row` and then add `SideMenu` as first child of that, like below:

```dart
PageController pageController = PageController();
SideMenuController sideMenu = SideMenuController();

@override
void initState() {
  // Connect SideMenuController and PageController together
  sideMenu.addListener((index) {
    pageController.jumpToPage(index);
  });
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SideMenu(
        // Page controller to manage a PageView
        controller: sideMenu,
        // Will shows on top of all items, it can be a logo or a Title text
        title: Image.asset('assets/images/easy_sidemenu.png'),
        // Will show on bottom of SideMenu when displayMode was SideMenuDisplayMode.open
        footer: Text('demo'),
        // Notify when display mode changed
        onDisplayModeChanged: (mode) {
          print(mode);
        },
        // List of SideMenuItem to show them on SideMenu
        items: items,
      ),
      Expanded(
        child: PageView(
          controller: pageController,
          children: [
            Container(
              child: Center(
                child: Text('Dashboard'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Expansion Item 1'),
              ),
            ),
            Container(
              child: Center(
                child: Text('Expansion Item 2'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
```

### Style

you can change style of side menu with `SideMenuStyle` :

```dart
SideMenuStyle(
  displayMode: SideMenuDisplayMode.auto,
  decoration: BoxDecoration(),
  openSideMenuWidth: 200,
  compactSideMenuWidth: 40,
  hoverColor: Colors.blue[100],
  selectedColor: Colors.lightBlue,
  selectedIconColor: Colors.white,
  unselectedIconColor: Colors.black54,
  backgroundColor: Colors.grey,
  selectedTitleTextStyle: TextStyle(color: Colors.white),
  unselectedTitleTextStyle: TextStyle(color: Colors.black54),
  iconSize: 20,
  itemBorderRadius: const BorderRadius.all(
    Radius.circular(5.0),
  ),
  showTooltip: true,
  showHamburger: true,
  itemHeight: 50.0,
  itemInnerSpacing: 8.0,
  itemOuterPadding: const EdgeInsets.symmetric(horizontal: 5.0),
  toggleColor: Colors.black54,

  // Additional properties for expandable items
  selectedTitleTextStyleExpandable: TextStyle(color: Colors.white), // Adjust the style as needed
  unselectedTitleTextStyleExpandable: TextStyle(color: Colors.black54), // Adjust the style as needed
  selectedIconColorExpandable: Colors.white, // Adjust the color as needed
  unselectedIconColorExpandable: Colors.black54, // Adjust the color as needed
  arrowCollapse: Colors.blueGrey, // Adjust the color as needed
  arrowOpen: Colors.lightBlueAccent, // Adjust the color as needed
  iconSizeExpandable: 24.0, // Adjust the size as needed
),
```

#### Style Example

<details>
<summary>Code</summary>

```dart
style: SideMenuStyle(
  displayMode: SideMenuDisplayMode.auto,
  hoverColor: Colors.blue[100],
  selectedColor: Colors.blue[600],
  selectedTitleTextStyle: TextStyle(color: Colors.white),
  selectedIconColor: Colors.white,
  unselectedIconColor: Colors.white70,
  unselectedTitleTextStyle: TextStyle(color: Colors.white70),
  showHamburger: false
  decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 79, 117, 134),
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(0, 0), // changes position of shadow
        ),
      ]),
  backgroundColor: Color.fromARGB(255, 79, 117, 134),
  // openSideMenuWidth: 200
),
```

</details>

![Open](images/Screenshot_style.png)

#### Style Props
| props                             | types          | description                                                                 |
|-----------------------------------|----------------|-----------------------------------------------------------------------------|
| displayMode                       | `SideMenuDisplayMode?` | SideMenuDisplayMode.auto, SideMenuDisplayMode.open, SideMenuDisplayMode.compact|
| decoration                        | `BoxDecoration?`    | Decoration of `SideMenu` background (container)                            |
| openSideMenuWidth                 | `double?`        | Width of `SideMenu` when displayMode was SideMenuDisplayMode.open          |
| compactSideMenuWidth              | `double?`        | Width of `SideMenu` when displayMode was SideMenuDisplayMode.compact       |
| hoverColor                        | `Color?`         | Color of `SideMenuItem` when mouse hover on that                           |
| selectedColor                     | `Color?`         | Background color of `SideMenuItem` when item is selected                   |
| selectedIconColor                 | `Color?`         | Color of icon when item is selected                                        |
| unselectedIconColor               | `Color?`         | Color of icon when item is unselected                                      |
| backgroundColor                   | `Color?`         | Background color of `SideMenu`                                             |
| selectedTitleTextStyle            | `TextStyle?`     | Style of `title` text when item is selected                                |
| unselectedTitleTextStyle          | `TextStyle?`     | Style of `title` text when item is unselected                              |
| iconSize                          | `double?`        | Size of icon on `SideMenuItem`                                             |
| toggleColor                       | `Color?`         | Color of toggle button                                                     |
| itemBorderRadius                  | `BorderRadius`   | Border Radius of menu item                                                 |
| showTooltip                       | `bool`           | Property that will show user itemName in Tooltip when they'll hover over the item|
| itemInnerSpacing                  | `double`         | Inner spacing of menu item                                                 |
| itemOuterPadding                  | `EdgeInsetsGeometry` | Outer padding of menu item                                              |
| itemHeight                        | `double`         | Height of menu item                                                        |
| showHamburger                     | `bool`           | Property that will show Hamburger on top-left corner if set as `true`      |
| selectedTitleTextStyleExpandable  | `TextStyle?`     | Style of `title` text when item is selected in `SideMenuExpandableItem`    |
| unselectedTitleTextStyleExpandable| `TextStyle?`     | Style of `title` text when item is unselected in `SideMenuExpandableItem`  |
| selectedIconColorExpandable       | `Color?`         | Color of icon when item is selected in `SideMenuExpandableItem`            |
| unselectedIconColorExpandable     | `Color?`         | Color of icon when item is unselected in `SideMenuExpandableItem`          |
| arrowCollapse                     | `Color?`         | Color of arrow in collapsed state in `SideMenuExpandableItem`              |
| arrowOpen                         | `Color?`         | Color of arrow in open state in `SideMenuExpandableItem`                   |
| iconSizeExpandable                | `double?`        | Size of icon on `SideMenuExpandableItem`                                   |



#### Thanks
Special thanks to [aditya113141](https://github.com/aditya113141) for contributing and implementing `SideMenuExpansionItem`


---

Feel free to fork this repository and send pull request 🏁👍

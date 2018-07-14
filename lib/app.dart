import 'package:flutter/material.dart';
import 'package:nested_navigation_demo_flutter/bottom_navigation.dart';
import 'package:nested_navigation_demo_flutter/tab_navigator.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  int page = 0;
  TabItem currentTab = TabItem.red;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.red: GlobalKey<NavigatorState>(),
    TabItem.green: GlobalKey<NavigatorState>(),
    TabItem.blue: GlobalKey<NavigatorState>(),
  };
  
  @override
  void initState() {
    pageController = new PageController(initialPage: this.page);
  }

  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
    });

    if (tabItem == TabItem.red) {
      pageController.jumpToPage(0);
    } else if (tabItem == TabItem.green) {
      pageController.jumpToPage(1);
    } else if (tabItem == TabItem.blue) {
      pageController.jumpToPage(2);
    }
  }
  
  void onPageChanged(int page) {
    setState(() {
      switch (page) {
        case 0:
            currentTab = TabItem.red;
          break;
        case 1:
            currentTab = TabItem.green;
          break;
        case 2:
            currentTab = TabItem.blue;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
        body: PageView(children: <Widget>[
          _buildNavigator(TabItem.red),
          _buildNavigator(TabItem.green),
          _buildNavigator(TabItem.blue),
        ],
        controller: pageController,
        onPageChanged: onPageChanged),
        bottomNavigationBar: BottomNavigation(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildNavigator(TabItem tabItem) {
    return TabNavigator(
      navigatorKey: navigatorKeys[tabItem],
      tabItem: tabItem,
    );
  }
}

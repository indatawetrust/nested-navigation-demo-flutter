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
      child: PageView(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.red),
          _buildOffstageNavigator(TabItem.green),
          _buildOffstageNavigator(TabItem.blue),
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

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}

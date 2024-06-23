import 'package:bottom_bar/bottom_bar.dart';
import 'package:charity_donation/BottomBar/TrendingScreen/trendingScreen.dart';
import 'package:charity_donation/Config/appColor.dart';
import 'package:charity_donation/BottomBar/HomeScreen/homeScreen.dart';
import 'package:charity_donation/BottomBar/NotificationScreen/notificationScreen.dart';
import 'package:charity_donation/BottomBar/SettingScreen/settingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class bottomBarPage extends StatefulWidget {
  const bottomBarPage({super.key});

  @override
  State<bottomBarPage> createState() => _bottomBarPageState();
}

class _bottomBarPageState extends State<bottomBarPage> {
  int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          homeScreen(),
          trendingScreen(),
          notificationScreen(),
          settingScreen()
        ],
        onPageChanged: (index) {
          // Use a better state management solution
          // setState is used for simplicity
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        backgroundColor: AppColor.whiteColor,
        showActiveBackgroundColor: true,
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: AppColor.appColor,
              inactiveColor: AppColor.greyColor.withOpacity(0.9)),
          BottomBarItem(
              icon: Icon(Icons.star_border_purple500_rounded),
              title: Text('Treanding'),
              activeColor: AppColor.appColor,
              inactiveColor: AppColor.greyColor.withOpacity(0.9)),
          BottomBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notification'),
              activeColor: AppColor.appColor,
              inactiveColor: AppColor.greyColor.withOpacity(0.9)),
          BottomBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: AppColor.appColor,
              inactiveColor: AppColor.greyColor.withOpacity(0.9)),
        ],
      ),
    );
  }
}

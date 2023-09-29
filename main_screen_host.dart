import 'package:flutter/material.dart';
import 'package:mad_project/screens/home_profile_tab.dart';
import 'package:mad_project/screens/home_screen.dart';
import 'package:mad_project/utils/constants.dart';

class MainScreenHost extends StatefulWidget {
  const MainScreenHost({Key? key}) : super(key: key);

  @override
  State<MainScreenHost> createState() => _MainScreenHostState();
}

class _MainScreenHostState extends State<MainScreenHost> {
  var currentIndex = 0;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return const HomeScreenTab();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return const HomeProfileTab();
      default:
        return const HomeScreenTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildTabContent(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: secondaryDark,
        unselectedItemColor: fontLight,
        items: [
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/home-1.png"), label: "Home"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/chart-vertical.png"),
              label: "Stat"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/wallet.png"), label: "Wallet"),
          BottomNavigationBarItem(
              icon: Image.asset("assets/icons/user-1.png"), label: "Profile"),
        ],
      ),
    );
  }
}

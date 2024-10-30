import 'package:flutter/material.dart';
import './mainfunction/nerarby/nearby_screen.dart';
import './mainfunction/saved/saved_screen.dart';
import './mainfunction/list/list_screen.dart';
import './mainfunction/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int current_index = 0;

  // Screens for each tab
  final List<Widget> screens = [
    NearbyScreen(),
    SavedScreen(),
    ListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[current_index],

      bottomNavigationBar: Container(
        color: Colors.white, //색상
        height: 80,
        child: BottomNavigationBar(
          currentIndex: current_index,
          onTap: (index) {
            setState(() {
              current_index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.share_location_outlined),
              label: '주변',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border_outlined),
              label: '저장',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_outlined),
              label: '목록',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: '마이',
            ),
          ],
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}


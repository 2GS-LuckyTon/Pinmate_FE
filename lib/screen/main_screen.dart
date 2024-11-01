import 'package:flutter/material.dart';
import './mainfunction/nerarby/nearby_screen.dart';
import './mainfunction/saved/saved_screen.dart';
import './mainfunction/list/list_screen.dart';
import './mainfunction/profile/profile_screen.dart';
import 'package:shared_map_app/screen/widgets/draggable_modal_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

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
      body: Stack(
        children: [
          screens[currentIndex], // 현재 탭 화면
          if (currentIndex == 0) // `지도` 인덱스에서만 DraggableModalSheet 표시
            DraggableModalSheet(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 80,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
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
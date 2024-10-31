import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import './make_list_screen.dart';
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  // 더미 데이터 리스트 생성
  final List<Map<String, dynamic>> savedItems = [
    {
      'icon': Icons.location_on_outlined,
      'color': Colors.pink,
      'title': '경주',
      'locationCount': 32,
      'sharedCount': 122,
      'mymine': false, // 내꺼 아님
      'reviewChecked': false, // 리뷰 미작성
    },
    {
      'icon': Icons.location_on_outlined,
      'color': Colors.pink,
      'title': '서울',
      'locationCount': 32,
      'sharedCount': 61,
      'mymine': true, // 내꺼
      'reviewChecked': true, // 내 리스트는 리뷰 속성 필요 없음
    },
    {
      'icon': Icons.location_on_outlined,
      'color': Colors.amber,
      'title': '맛방대지도',
      'locationCount': 32,
      'sharedCount': 61,
      'mymine': false, // 상대꺼
      'reviewChecked': true, // 리뷰 작성 완료
    },
  ];

  @override
  Widget build(BuildContext context) {


    Future<void> _openMakeListScreen() {
      return Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MakeListScreen(),
        ),
      );
    }



    // mymine 값에 따라 리스트 분리
    final List<Map<String, dynamic>> myList = savedItems.where((item) => item['mymine'] == true).toList();
    final List<Map<String, dynamic>> otherList = savedItems.where((item) => item['mymine'] == false).toList();

    return Stack(
      children: [
        Container(
          child: ListView(
            padding: EdgeInsets.only(top: 0.2.sw),
            children: [
              // 내 리스트 섹션
              if (myList.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    '내 리스트',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                ...myList.map((item) => buildListItem(item)).toList(),
              ],
              // 상대 리스트 섹션
              if (otherList.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    '상대 리스트',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
                ...otherList.map((item) => buildListItem(item)).toList(),
              ],
            ],
          ),
        ),
        // 고정 버튼 추가
        Positioned(
          bottom: 20.0,
          left: 90,
          right: 90,
          child: Center(
            child: GestureDetector(
              onTap: () {
                _openMakeListScreen(); // 버튼을 눌렀을 때 _openMakeListScreen 함수 호출
              },
              child: Container(
                height: 0.05.sh,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.blueAccent, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_add_outlined, color: Colors.blue),
                    SizedBox(width: 10),
                    Text(
                      '리스트 만들기',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  // 리스트 아이템을 생성하는 메서드
  Widget buildListItem(Map<String, dynamic> item) {
    return ListTile(
      leading: Icon(item['icon'], color: item['color']),
      title: Text(item['title']),
      subtitle: Row(
        children: [
          Icon(Icons.location_on, size: 14, color: Colors.grey),
          Text('${item['locationCount']}'),
          SizedBox(width: 10),
          Icon(Icons.share_outlined, size: 14, color: Colors.grey),
          Text('${item['sharedCount']}'),
        ],
      ),
      trailing: item['mymine'] == false && item['reviewChecked'] == false
          ? TextButton(
        onPressed: () {
          // 리뷰 쓰기 버튼 눌렀을 때 동작 추가
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.redAccent.withOpacity(0.1),
        ),
        child: Text(
          '리뷰 쓰기',
          style: TextStyle(color: Colors.red),
        ),
      )
          : null, // 리뷰 완료 혹은 내 리스트에는 버튼 없음
      onTap: () {
        // 리스트 항목 선택 시 동작
      },
    );
  }
}

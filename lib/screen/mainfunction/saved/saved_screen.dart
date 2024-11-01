import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import './make_list_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../list/list_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  // 서버에서 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> _fetchSavedItems() async {
    try {
      final response = await http.get(Uri.parse('https://your-api-url.com/api/saved-items')); // 실제 API URL로 변경해야 합니다.

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load saved items');
      }
    } catch (e) {
      // 에러 발생 시 더미 데이터 반환
      return _getDummyData();
    }
  }

  // 더미 데이터 반환 함수
  List<Map<String, dynamic>> _getDummyData() {
    return [
      {
        'id':1,
        'color': 20,
        'title': '경주',
        'locationCount': 32,
        'sharedCount': 122,
        'mymine': false, // 내꺼 아님
        'reviewChecked': false, // 리뷰 미작성
      },
      {
        'id':2,
        'color': 60,
        'title': '서울',
        'locationCount': 32,
        'sharedCount': 61,
        'mymine': true, // 내꺼
        'reviewChecked': true, // 내 리스트는 리뷰 속성 필요 없음
      },
    ];
  }

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

    return Stack(
      children: [
        Container(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchSavedItems(), // 서버에서 데이터 fetch
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); // 로딩 중일 때
              } else if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}')); // 에러 발생 시
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('저장된 항목이 없습니다.')); // 데이터가 없을 경우
              }

              final List<Map<String, dynamic>> savedItems = snapshot.data!;

              // mymine 값에 따라 리스트 분리
              final List<Map<String, dynamic>> myList = savedItems.where((item) => item['mymine'] == true).toList();
              final List<Map<String, dynamic>> otherList = savedItems.where((item) => item['mymine'] == false).toList();

              return ListView(
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
              );
            },
          ),
        ),
        // 고정 버튼 추가
        Positioned(
          bottom: 20.0,
          left: 90,
          right: 90,
          child: Center(
            child: GestureDetector(
              onTap: _openMakeListScreen, // 버튼을 눌렀을 때 _openMakeListScreen 함수 호출
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
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
    double hue = item['color'] is int ? (item['color'] as int).toDouble() : 0.0;
    Color color = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(); // Create color from hue
    return ListTile(
      leading: Icon(Icons.location_on_outlined, color: color),
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
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ListDetailScreen(
              title: item['title'],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON을 사용하기 위해 import합니다.
import 'package:shared_map_app/screen/mainfunction/list/list_detail_screen.dart';
import '../mainfunction/saved/make_list_screen.dart';

class DraggableModalSheet extends StatelessWidget {
  const DraggableModalSheet({Key? key}) : super(key: key);

  // 서버에서 데이터를 받아오는 함수
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
        'color': 20,
        'title': '경주',
        'locationCount': 32,
        'sharedCount': 122,
        'mymine': false,
        'places': [
          {
            'title': '경주 대릉원',
            'latitude': 35.8352,
            'longitude': 129.2190,
            'description': '경주의 대표적인 고분군',
          },
          {
            'title': '경주 불국사',
            'latitude': 35.7894,
            'longitude': 129.3312,
            'description': '유네스코 세계문화유산',
          },
        ],
      },
      {
        'color': 40,
        'title': '서울',
        'locationCount': 32,
        'sharedCount': 61,
        'mymine': true,
        'places': [
          {
            'title': '인천대 공학대학',
            'latitude': 37.3757,
            'longitude': 126.6323,
            'description': '공학 분야 교육의 중심지',
          },
          {
            'title': '인천대학교 학산도서관',
            'latitude': 37.3747,
            'longitude': 126.6322,
            'description': '학습과 연구를 위한 도서관',
          },
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
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

              final List<Map<String, dynamic>> myList = savedItems.where((item) => item['mymine'] == true).toList();
              final List<Map<String, dynamic>> otherList = savedItems.where((item) => item['mymine'] == false).toList();

              return ListView(
                padding: EdgeInsets.only(top: 5),
                controller: scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.add_circle_outline, color: Colors.blue),
                    title: Text('새 리스트 만들기'),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => MakeListScreen(),
                        ),
                      );
                    },
                  ),
                  if (myList.isNotEmpty) ...[
                    ...myList.map((item) => buildListItem(context, item)).toList(),
                  ],
                  if (otherList.isNotEmpty) ...[
                    ...otherList.map((item) => buildListItem(context, item)).toList(),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget buildListItem(BuildContext context, Map<String, dynamic> item) {
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

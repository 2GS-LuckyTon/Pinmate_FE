import 'package:flutter/material.dart';
import '../../main_screen.dart';


class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}
class _ListScreenState extends State<ListScreen> {
  // 예시 데이터
  final List<String> categories = ["술집", "맛집", "카페", "여행지", "기타"];
  final List<Map<String, dynamic>> hotList = [
    {"title": "Title", "content": "content", "scrap": 500},
    {"title": "Title", "content": "content", "scrap": 500},
    {"title": "Title", "content": "content", "scrap": 500},
    {"title": "Title", "content": "content", "scrap": 500},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색 바
            TextField(
              decoration: InputDecoration(
                hintText: '리스트 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            SizedBox(height: 20),

            // 카테고리 목록 (그리드 레이아웃)
            Text("리스트 태그", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey[300],
                    ),
                    Text(categories[index], style: TextStyle(fontSize: 12)),
                  ],
                );
              },
            ),
            SizedBox(height: 20),

            // Hot list 제목
            Text("hot list", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Hot list 목록 (무한 스크롤 구현 가능)
            Expanded(
              child: ListView.builder(
                itemCount: hotList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey[300],
                    ),
                    title: Text(hotList[index]["title"]),
                    subtitle: Text(hotList[index]["content"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bookmark_outline),
                        SizedBox(width: 5),
                        Text(hotList[index]["scrap"].toString()),
                      ],
                    ),
                    onTap: () {
                      // 아이템 클릭 시 동작
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../main_screen.dart';
import 'list_detail_screen.dart';
import 'tag_list_screen.dart'; // TagListScreen import

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<String> categories = ["술집", "맛집", "카페", "여행지", "기타"];
  final List<Map<String, dynamic>> Lists = [
    {"title": "Title", "subTitle": "ddkdkdk", "sharedCount": 500, "color": Colors.blue},
    {"title": "Title", "subTitle": "zzzzz", "sharedCount": 200, "color": Colors.yellow},
    {"title": "Title", "subTitle": "ddddddd", "sharedCount": 400, "color": Colors.red},
    {"title": "Title", "subTitle": "zz", "sharedCount": 100, "color": Colors.blue},
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
            SizedBox(height: 0.1.sw),
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
                return GestureDetector(
                  onTap: () {
                    // 리스트 태그 클릭 시 TagListScreen으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TagListScreen(category: categories[index]),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.grey[300],
                      ),
                      Text(categories[index], style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Hot list 제목
            Text("Top 20", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Hot list 목록 (무한 스크롤 구현 가능)
            Expanded(
              child: ListView.builder(
                itemCount: Lists.length,
                itemBuilder: (context, index) {
                  final hotItem = Lists[index];

                  return ListTile(
                    leading:
                    Icon(Icons.location_on_outlined, color: hotItem["color"],size: 30,),
                    title: Text(hotItem["title"] ?? "Unknown Title"), // Default title if null
                    subtitle: Text(hotItem["subTitle"] ?? "Unknown subTitle"), // Default tag if null
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share_outlined),
                        SizedBox(width: 5),
                        Text(hotItem["sharedCount"]?.toString() ?? "0"), // Default to "0" if null
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListDetailScreen(),
                        ),
                      );
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

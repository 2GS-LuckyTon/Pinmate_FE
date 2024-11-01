import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'list_detail_screen.dart';
import 'tag_list_screen.dart';

// Define a list of hues and colors for indexed access
const List<int> hueValues = [20, 60, 100, 140, 180, 220, 260, 300];
const List<Color> hueColors = [
  Color(0xFFD68A2B), // Hue 20
  Color(0xFFE8D92B), // Hue 60
  Color(0xFF5CCF4E), // Hue 100
  Color(0xFF2FBC6D), // Hue 140
  Color(0xFF28B2B5), // Hue 180
  Color(0xFF2B98E8), // Hue 220
  Color(0xFF5C5EE8), // Hue 260
  Color(0xFFC77DFF), // Hue 300
];

// Function to retrieve color from hue value directly
Color getColorFromHue(int hue) {
  int index = hueValues.indexOf(hue); // Find the index of the hue value
  if (index != -1) {
    return hueColors[index];
  } else {
    return Colors.grey; // Default color if hue is not found
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<Map<String, dynamic>> categories = [
    {"name": "술집", "icon": Icons.local_bar},
    {"name": "맛집", "icon": Icons.restaurant},
    {"name": "카페", "icon": Icons.local_cafe},
    {"name": "여행지", "icon": Icons.map},
    {"name": "기타", "icon": Icons.category},
  ];

  final List<Map<String, dynamic>> lists = [
    {
      "title": "경주",
      "subTitle": "핫한 관광지",
      "locationCount": 32,
      "sharedCount": 122,
      "color": 20, // Specify hue value directly
      "tags": ["여행지"],
      "places": [
        {"title": "경주 대릉원", "latitude": 35.8352, "longitude": 129.2190, "description": "경주의 대표적인 고분군"},
        {"title": "경주 불국사", "latitude": 35.7894, "longitude": 129.3312, "description": "유네스코 세계문화유산"},
      ]
    },
    {
      "title": "서울",
      "subTitle": "도심 명소",
      "locationCount": 32,
      "sharedCount": 61,
      "color": 60,
      "tags": ["여행지", "맛집"],
      "places": [
        {"title": "인천대 공학대학", "latitude": 37.3757, "longitude": 126.6323, "description": "공학 분야 교육의 중심지"},
        {"title": "인천대학교 학산도서관", "latitude": 37.3747, "longitude": 126.6322, "description": "학습과 연구를 위한 도서관"},
      ]
    },
    {
      "title": "맛방대지도",
      "subTitle": "맛집 가이드",
      "locationCount": 32,
      "sharedCount": 61,
      "color": 100,
      "tags": ["맛집"],
      "places": []
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TagListScreen(
                          category: category["name"],
                          lists: lists,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category["icon"],
                          size: 28,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(category["name"], style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text("Top 20", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final listItem = lists[index];
                  final itemColor = getColorFromHue(listItem["color"]); // Use hue value directly to get color

                  return ListTile(
                    leading: Icon(Icons.location_pin, color: itemColor, size: 30),
                    title: Text(listItem["title"] ?? "Unknown Title"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listItem["subTitle"] ?? "Unknown subTitle"),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey),
                            Text(listItem["locationCount"].toString()),
                            SizedBox(width: 10),
                            Icon(Icons.share_outlined, size: 16, color: Colors.grey),
                            Text(listItem["sharedCount"].toString()),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListDetailScreen(title: listItem["title"]),
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
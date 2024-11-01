import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 예시 데이터
  final String userName = "사용자 닉네임";
  final List<Map<String, dynamic>> reviews = [
    {"title": "Title 1", "content": "Content 1"},
    {"title": "Title 2", "content": "Content 2"},
    {"title": "Title 3", "content": "Content 3"},
    {"title": "Title 4", "content": "Content 4"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PinMate 사랑해주세요"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 프로필 영역
            Row(
              children: [
                // 사용자 이미지
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 16),
                // 사용자 닉네임 및 수정 버튼
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // 사용자 정보 수정 기능 구현
                      },
                      child: Text("정보 수정"),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // "내가 남긴 리뷰" 제목
            Text(
              "내가 남긴 리뷰",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // 내가 남긴 리뷰 리스트 (무한 스크롤)
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey[300],
                    ),
                    title: Text(reviews[index]["title"]),
                    subtitle: Text(reviews[index]["content"]),
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
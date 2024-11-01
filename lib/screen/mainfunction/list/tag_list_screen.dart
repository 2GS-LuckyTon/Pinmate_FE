import 'package:flutter/material.dart';

class TagListScreen extends StatefulWidget {
  final String category;

  TagListScreen({required this.category});

  @override
  _TagListScreenState createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTagIndex = 0;

  // 예시 데이터
  final List<String> tags = ["술집", "맛집", "카페", "여행지", "기타"];
  final List<Map<String, dynamic>> listData = [
    {"title": "Title 1", "content": "content 1", "scrap": 500},
    {"title": "Title 2", "content": "content 2", "scrap": 300},
    {"title": "Title 3", "content": "content 3", "scrap": 800},
    {"title": "Title 4", "content": "content 4", "scrap": 200},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("장소 검색"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '장소 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          SizedBox(height: 10),
          // 태그 목록 (좌우 스크롤 가능)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tags.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(tags[index]),
                    selected: selectedTagIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedTagIndex = index;
                      });
                    },
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: selectedTagIndex == index ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 10),
          // 정렬 버튼 (최신순, 저장 많은순)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _tabController.index = 0; // 최신순 탭으로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: _tabController.index == 0 ? Colors.blue : Colors.grey[200],
                    foregroundColor: _tabController.index == 0 ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("최신순"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _tabController.index = 1; // 저장 많은순 탭으로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: _tabController.index == 1 ? Colors.blue : Colors.grey[200],
                    foregroundColor: _tabController.index == 1 ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("저장 많은순"),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // 최신순 및 저장 많은순 탭 내용
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 최신순 탭
                ListView.builder(
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        color: Colors.grey[300],
                      ),
                      title: Text(listData[index]["title"]),
                      subtitle: Text(listData[index]["content"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bookmark_outline),
                          SizedBox(width: 5),
                          Text(listData[index]["scrap"].toString()),
                        ],
                      ),
                      onTap: () {
                        // 리스트 항목을 클릭했을 때의 동작 (예: 상세 페이지 이동)
                      },
                    );
                  },
                ),
                // 저장 많은순 탭
                ListView.builder(
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    List<Map<String, dynamic>> sortedList = List.from(listData);
                    sortedList.sort((a, b) => b["scrap"].compareTo(a["scrap"]));

                    return ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        color: Colors.grey[300],
                      ),
                      title: Text(sortedList[index]["title"]),
                      subtitle: Text(sortedList[index]["content"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bookmark_outline),
                          SizedBox(width: 5),
                          Text(sortedList[index]["scrap"].toString()),
                        ],
                      ),
                      onTap: () {
                        // 리스트 항목을 클릭했을 때의 동작 (예: 상세 페이지 이동)
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
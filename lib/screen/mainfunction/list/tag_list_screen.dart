import 'package:flutter/material.dart';
import 'list_detail_screen.dart';

class TagListScreen extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> lists;

  TagListScreen({required this.category, required this.lists});

  @override
  _TagListScreenState createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTagIndex = 0;
  List<Map<String, dynamic>> filteredList = [];

  final List<String> tags = ["술집", "맛집", "카페", "여행지", "기타"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedTagIndex = tags.indexOf(widget.category); // Set initial tag index
    _filterListByTag(widget.category);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Filter list based on selected tag
  void _filterListByTag(String tag) {
    setState(() {
      filteredList = widget.lists.where((item) => item['tags'].contains(tag)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("장소 검색")),
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
                        _filterListByTag(tags[index]);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => _tabController.index = 0,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: _tabController.index == 0 ? Colors.blue : Colors.grey[200],
                    foregroundColor: _tabController.index == 0 ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("최신순"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _tabController.index = 1,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: _tabController.index == 1 ? Colors.blue : Colors.grey[200],
                    foregroundColor: _tabController.index == 1 ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("저장 많은순"),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(filteredList),
                _buildListView(List.from(filteredList)..sort((a, b) => b["sharedCount"].compareTo(a["sharedCount"]))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return ListTile(
          leading: Icon(Icons.location_pin, color: item["color"], size: 30),
          title: Text(item["title"]),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item["subTitle"]),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  Text(item["locationCount"].toString()),
                  SizedBox(width: 10),
                  Icon(Icons.share_outlined, size: 16, color: Colors.grey),
                  Text(item["sharedCount"].toString()),
                ],
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListDetailScreen(title: item["title"]),
              ),
            );
          },
        );
      },
    );
  }
}
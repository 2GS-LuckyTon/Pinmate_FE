import 'package:flutter/material.dart';
import 'package:shared_map_app/screen/mainfunction/list/list_detail_screen.dart';

class DraggableModalSheet extends StatefulWidget {
  const DraggableModalSheet({Key? key}) : super(key: key);

  @override
  _DraggableModalSheetState createState() => _DraggableModalSheetState();
}

class _DraggableModalSheetState extends State<DraggableModalSheet> {
  List<Map<String, dynamic>> _listItems = [
    {
      "title": "경주",
      "locationCount": 32,
      "photoCount": 122,
      "icon": Icons.star,
      "color": Colors.pink,
    },
    {
      "title": "서울",
      "locationCount": 32,
      "photoCount": 61,
      "icon": Icons.star,
      "color": Colors.pink,
    },
    {
      "title": "맛방대지도",
      "locationCount": null,
      "photoCount": null,
      "icon": Icons.food_bank,
      "color": Colors.amber,
    },
  ];

  void _addNewList() {
    setState(() {
      _listItems.add({
        "title": "새로운 리스트 ${_listItems.length + 1}",
        "locationCount": 0,
        "photoCount": 0,
        "icon": Icons.list_alt,
        "color": Colors.blue,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: _listItems.length + 2, // +2 for the draggable handle and "새 리스트 만들기" button
            itemBuilder: (context, index) {
              if (index == 0) {
                // 드래그 핸들
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                );
              } else if (index == 1) {
                // "새 리스트 만들기" 버튼
                return ListTile(
                  leading: Icon(Icons.add_circle_outline, color: Colors.blue),
                  title: Text('새 리스트 만들기'),
                  onTap: _addNewList, // 새 리스트 추가
                );
              }

              // 동적 리스트 항목
              final item = _listItems[index - 2];
              return ListTile(
                leading: Icon(item["icon"], color: item["color"]),
                title: Text(item["title"]),
                subtitle: item["locationCount"] != null
                    ? Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    Text('${item["locationCount"]}'),
                    SizedBox(width: 10),
                    Icon(Icons.photo_library, size: 14, color: Colors.grey),
                    Text('${item["photoCount"]}'),
                  ],
                )
                    : null,
                trailing: item["title"] == "맛방대지도"
                    ? ElevatedButton(
                  onPressed: () {
                    // 리뷰 남기기 기능 구현
                  },
                  child: Text('리뷰 남기러 가기'),
                )
                    : null,
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
        );
      },
    );
  }
}
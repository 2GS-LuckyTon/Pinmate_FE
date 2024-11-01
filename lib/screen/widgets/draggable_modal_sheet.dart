import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_map_app/screen/mainfunction/list/list_detail_screen.dart';
import '../mainfunction/saved/make_list_screen.dart';

class DraggableModalSheet extends StatelessWidget {
  const DraggableModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> savedItems = [
      {
        'icon': Icons.location_on_outlined,
        'color': Colors.pink,
        'title': '경주',
        'locationCount': 32,
        'sharedCount': 122,
        'mymine': false,
      },
      {
        'icon': Icons.location_on_outlined,
        'color': Colors.pink,
        'title': '서울',
        'locationCount': 32,
        'sharedCount': 61,
        'mymine': true,
      },
      {
        'icon': Icons.location_on_outlined,
        'color': Colors.amber,
        'title': '맛방대지도',
        'locationCount': 32,
        'sharedCount': 61,
        'mymine': true,
      },
    ];

    Future<void> _openMakeListScreen() {
      return Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MakeListScreen(),
        ),
      );
    }

    final List<Map<String, dynamic>> myList = savedItems.where((item) => item['mymine'] == true).toList();
    final List<Map<String, dynamic>> otherList = savedItems.where((item) => item['mymine'] == false).toList();

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
          child: ListView(
            padding: EdgeInsets.only(top:5),
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
                  _openMakeListScreen();
                },
              ),
              if (myList.isNotEmpty) ...[
                ...myList.map((item) => buildListItem(context, item)).toList(),
              ],
              if (otherList.isNotEmpty) ...[
                ...otherList.map((item) => buildListItem(context, item)).toList(),
              ],
            ],
          ),
        );
      },
    );
  }
}

Widget buildListItem(BuildContext context, Map<String, dynamic> item) {
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
    onTap: () {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ListDetailScreen(title: item['title']),
        ),
      );
    },
  );
}
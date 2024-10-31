import 'package:flutter/material.dart';

class DraggableModalSheet extends StatelessWidget {
  const DraggableModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Padding(
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
              ),
              ListTile(
                leading: Icon(Icons.add_circle_outline, color: Colors.blue),
                title: Text('새 리스트 만들기'),
                onTap: () {
                  // 새 리스트 추가 기능 구현
                },
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.pink),
                title: Text('경주'),
                subtitle: Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    Text('32'),
                    SizedBox(width: 10),
                    Icon(Icons.photo_library, size: 14, color: Colors.grey),
                    Text('122'),
                  ],
                ),
                onTap: () {
                  // 경주 리스트 선택 시 동작
                },
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.pink),
                title: Text('서울'),
                subtitle: Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    Text('32'),
                    SizedBox(width: 10),
                    Icon(Icons.photo_library, size: 14, color: Colors.grey),
                    Text('61'),
                  ],
                ),
                onTap: () {
                  // 서울 리스트 선택 시 동작
                },
              ),
              ListTile(
                leading: Icon(Icons.food_bank, color: Colors.amber),
                title: Text('맛방대지도'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // 리뷰 남기기 기능
                  },
                  child: Text('리뷰 남기러 가기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
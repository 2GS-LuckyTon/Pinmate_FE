// search_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchDetailScreen extends StatefulWidget {
  @override
  _SearchDetailScreenState createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  // 검색된 장소들을 저장할 리스트
  List places = [];

  Future<void> _searchPlaces(String query) async {
    // 실제 검색 로직 구현 (예: Google Places API)
    // 결과를 가져와 `places` 리스트에 추가합니다.
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("장소 검색")),
      body: Column(
        children: [
          TextField(
            onChanged: (query) {
              _searchPlaces(query); // 검색어 입력 시 검색 수행
            },
            decoration: InputDecoration(
              hintText: '장소 검색',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return ListTile(
                  title: Text(place.name),
                  onTap: () {
                    Navigator.pop(context, place.location); // 장소 선택 시 위치 정보 반환
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

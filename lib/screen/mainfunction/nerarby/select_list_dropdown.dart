import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectListDropdown extends StatefulWidget {
  final Function(Map<String, dynamic>) onListSelected; // 선택된 리스트 전체를 반환

  const SelectListDropdown({
    Key? key,
    required this.onListSelected,
  }) : super(key: key);

  @override
  State<SelectListDropdown> createState() => _SelectListDropdownState();
}

class _SelectListDropdownState extends State<SelectListDropdown> {
  // 서버에서 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> _fetchListOptions() async {
    try {
      final response = await http.get(Uri.parse('https://your-api-url.com/api/list-options')); // 실제 API URL로 변경해야 합니다.

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load list options');
      }
    } catch (e) {
      // 에러 발생 시 더미 데이터를 반환
      return _getDummyData();
    }
  }

  // 더미 데이터 반환 함수
  List<Map<String, dynamic>> _getDummyData() {
    return [
      {"id": "1", "title": "Shopping List", "color": 120},
      {"id": "2", "title": "Travel Plans", "color": 240},
      {"id": "3", "title": "Wishlist", "color": 360},
      {"id": "4", "title": "Favorites", "color": 60},
    ];
  }

  Map<String, dynamic>? _selectedList; // 선택된 리스트

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchListOptions(), // 서버에서 데이터 fetch
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // 로딩 중일 때
        } else if (snapshot.hasError) {
          return Text('오류 발생: ${snapshot.error}'); // 에러 발생 시
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('리스트가 없습니다.'); // 데이터가 없을 경우
        }

        final listOptions = snapshot.data!;

        return DropdownButton<Map<String, dynamic>>(
          hint: Text('리스트를 선택하세요'), // 드롭다운 메뉴에 힌트 표시
          value: _selectedList,
          items: listOptions.map((Map<String, dynamic> list) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: list,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: HSVColor.fromAHSV(1, (list['color'] as int).toDouble(), 1, 1).toColor(), // 리스트 색상에 따른 아이콘 색상
                  ),
                  SizedBox(width: 8),
                  Text(list['title']), // 리스트 이름
                ],
              ),
            );
          }).toList(),
          onChanged: (Map<String, dynamic>? newValue) {
            setState(() {
              _selectedList = newValue; // 선택된 리스트 업데이트
            });
            if (newValue != null) {
              widget.onListSelected(newValue); // 선택된 리스트 ID 전달
            }
          },
          isExpanded: true, // 드롭다운 메뉴 너비를 부모 너비에 맞춤
        );
      },
    );
  }
}

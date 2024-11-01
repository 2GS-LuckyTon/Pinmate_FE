import 'package:flutter/material.dart';

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
  // 리스트 이름, ID, 색상을 포함한 더미 데이터
  List<Map<String, dynamic>> _listOptions = [
    {"id": "1", "name": "Shopping List", "color": 120},
    {"id": "2", "name": "Travel Plans", "color": 240},
    {"id": "3", "name": "Wishlist", "color": 360},
    {"id": "4", "name": "Favorites", "color": 60},
  ];

  Map<String, dynamic>? _selectedList; // 선택된 리스트

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Map<String, dynamic>>(
      hint: Text('리스트를 선택하세요'), // 드롭다운 메뉴에 힌트 표시
      value: _selectedList,
      items: _listOptions.map((Map<String, dynamic> list) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: list,
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: HSVColor.fromAHSV(1, (list['color'] as int).toDouble(), 1, 1).toColor(), // 리스트 색상에 따른 아이콘 색상
              ),
              SizedBox(width: 8),
              Text(list['name']), // 리스트 이름
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
  }
}

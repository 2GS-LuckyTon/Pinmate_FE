import 'package:flutter/material.dart';
import './select_list_dropdown.dart';

class PlaceSaveDialog extends StatefulWidget {
  final Map<String, dynamic> result;
  final Function(Map<String, dynamic>) onAdd; // 선택된 리스트를 전달하기 위한 콜백

  const PlaceSaveDialog({
    Key? key,
    required this.result,
    required this.onAdd,
  }) : super(key: key);

  @override
  _PlaceSaveDialogState createState() => _PlaceSaveDialogState();
}

class _PlaceSaveDialogState extends State<PlaceSaveDialog> {
  Map<String, dynamic>? selectedList; // 선택된 리스트 저장

  @override
  Widget build(BuildContext context) {
    // Google Places API 결과에서 필요한 정보 추출
    final String name = widget.result['name'] ?? '알 수 없는 장소';
    final String address = widget.result['address'] ?? '주소 정보 없음';
    final int? rating = widget.result['rating'];
    final int? userRatingsTotal = widget.result['user_ratings_total'];
    final String? phoneNumber = widget.result['phoneNumber'];

    return AlertDialog(
      title: Text('$name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주소: $address'),
          SizedBox(height: 8),
          if (rating != null) ...[
            Text('평점: $rating / 5.0'),
            SizedBox(height: 4),
          ],
          if (userRatingsTotal != null) ...[
            Text('리뷰 수: $userRatingsTotal'),
            SizedBox(height: 16),
          ],
          if (phoneNumber != null) ...[
            Text('전화번호: $phoneNumber'),
            SizedBox(height: 16),
          ],
          SelectListDropdown(
            onListSelected: (list) {
              setState(() {
                selectedList = list; // 선택된 리스트 업데이트
              });
              print('선택된 리스트: $selectedList');
            },
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (selectedList != null) {
              widget.onAdd(selectedList!); // 선택된 리스트 전달
            }
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: Text('추가'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}

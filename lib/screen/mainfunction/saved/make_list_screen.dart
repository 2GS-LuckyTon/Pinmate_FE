import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class MakeListScreen extends StatefulWidget {
  const MakeListScreen({super.key});

  @override
  State<MakeListScreen> createState() => _MakeListScreenState();
}

class _MakeListScreenState extends State<MakeListScreen> {
  final TextEditingController _titleController = TextEditingController();
  Color? selectedColor;
  double? seletedColor_hug;
  final List<int> colorOptions = [
    20,  // Color(0xFFD68A2B)
    60,  // Color(0xFFE8D92B)
    100, // Color(0xFF5CCF4E)
    140, // Color(0xFF2FBC6D)
    180, // Color(0xFF28B2B5)
    220, // Color(0xFF2B98E8)
    260, // Color(0xFF5C5EE8)
    300, // Color(0xFFC77DFF)
  ];
  String? errorText;

  final List<String> tags = ["술집", "맛집", "카페", "여행지", "기타"];
  String? _selectedTag;

  Future<void> _createList() async {
    if (_titleController.text.isEmpty || _selectedTag == null || selectedColor == null) {
      setState(() {
        errorText = _titleController.text.isEmpty ? "빈칸입니다!" : "태그를 선택하세요!";
      });
      return;
    }

    setState(() {
      errorText = null;
    });

    // Color가 선택된 경우 hue 값을 추출
    if (selectedColor != null) { // 추가된 null 체크
    print(seletedColor_hug);
      // POST request
      final response = await http.post(
        Uri.parse('https://your-api-url.com/api/list'),
        body: {
          'title': _titleController.text,
          'color': seletedColor_hug, // hue를 문자열로 변환
          'tag': _selectedTag!,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Go back to the previous screen
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('리스트 생성 실패')),
        );
      }
    } else {
      // 색상이 선택되지 않았을 경우의 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('색상을 선택하세요!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("새 리스트 추가"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: "리스트 제목 (20자 이내)",
                    border: OutlineInputBorder(),
                    counterText: "",
                    errorText: errorText,
                  ),
                ),
                SizedBox(height: 20),
                Text("태그 선택", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) {
                    final isSelected = _selectedTag == tag;
                    return ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTag = selected ? tag : null;
                        });
                      },
                      selectedColor: Colors.blueAccent,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text("색상 선택", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Center(
                  child: Wrap(
                    spacing: 10,
                    children: colorOptions.map((color_hug) {
                      double hue = color_hug is int ? (color_hug as int).toDouble() : 0.0;
                      Color color = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(); // Create color from hue

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                            seletedColor_hug = hue;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color ? Colors.blue : Colors.transparent,
                              width: selectedColor == color ? 4 : 2,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: selectedColor == color ? 12 : 15,
                            child: selectedColor == color ? Icon(Icons.check, color: Colors.white) : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Spacer(),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 30,
              right: 30,
              child: Center(
                child: GestureDetector(
                  onTap: _createList,
                  child: Container(
                    height: 0.06.sh,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '리스트 생성',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  final List<Color> colorOptions = [
    Colors.red, Colors.blue, Colors.green, Colors.yellow,
    Colors.orange, Colors.purple, Colors.grey, Colors.greenAccent,
  ];
  String? errorText;

  Future<void> _createList() async {
    if (_titleController.text.isEmpty) {
      setState(() {
        errorText = "빈칸입니다!";
      });
      return;
    }

    setState(() {
      errorText = null;
    });

    final chosenColor = selectedColor?.value.toString() ?? Colors.blue.value.toString();
    // POST request
    final response = await http.post(
      Uri.parse('https://your-api-url.com/api/list'),
      body: {
        'title': _titleController.text,
        'color': chosenColor,
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
                SizedBox(height: 40),
                Text("색상 선택", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Center(
                  child: Wrap(
                    spacing: 10,
                    children: colorOptions.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
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

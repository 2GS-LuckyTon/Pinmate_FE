import 'package:flutter/material.dart';
import './nearby_api.dart';

class SearchDetailScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  // 위도와 경도를 생성자에서 받아오는 구조로 수정합니다.
  SearchDetailScreen({required this.latitude, required this.longitude});

  @override
  _SearchDetailScreenState createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  List<Map<String, dynamic>> places = [];
  bool isLoading = false;
  String errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 초기 위치 기반으로 장소 검색을 시작합니다.
    _searchNearbyPlaces();
  }

  Future<void> _searchNearbyPlaces({String query = ''}) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // 위도와 경도를 widget.latitude, widget.longitude로 접근합니다.
      final results = await getNearbyPlaces(widget.latitude, widget.longitude, query: query);
      setState(() {
        places = results;
        isLoading = false;
      });
      print(places);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = '장소 검색 중 오류가 발생했습니다: $e';
      });
      print('Error searching places: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("장소 검색")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '장소 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchNearbyPlaces(query: value);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return ListTile(
                  title: Text(place['name'] ?? 'No name'),
                  subtitle: Text(place['address'] ?? 'No address'),
                  onTap: () {
                    Navigator.pop(context, place);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

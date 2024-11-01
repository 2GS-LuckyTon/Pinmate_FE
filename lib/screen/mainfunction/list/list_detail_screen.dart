import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListDetailScreen extends StatefulWidget {
  @override
  _ListDetailScreenState createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  late GoogleMapController _mapController;
  final List<Marker> _markers = []; // 리스트 내 장소에 대한 마커

  @override
  void initState() {
    super.initState();
    // 리스트 장소 데이터를 가져와 마커를 초기화하는 로직을 여기에 추가
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // 지도에 마커를 추가하는 코드 작성
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 지도
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194), // 초기 위치
              zoom: 12,
            ),
            markers: Set.from(_markers),
          ),
          // 왼쪽 상단 닫기 버튼
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context); // 이전 화면으로 돌아가기
              },
            ),
          ),
          // Draggable Modal
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.9,
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
                    // 모달 상단 부분 (리스트 이름 및 저장 상태)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('리스트 이름', style: TextStyle(fontSize: 18)),
                          ElevatedButton.icon(
                            onPressed: () {
                              // 저장 상태 토글 로직
                            },
                            icon: Icon(Icons.check_box),
                            label: Text('저장됨'),
                          ),
                        ],
                      ),
                    ),
                    // TabBar 및 TabBarView
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: [
                              Tab(text: '장소'),
                              Tab(text: '리뷰'),
                            ],
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                          ),
                          Container(
                            height: 400, // 높이 지정
                            child: TabBarView(
                              children: [
                                // 장소 탭
                                ListView.builder(
                                  itemCount: 20, // 실제 데이터 수로 대체
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text('장소 이름 $index'),
                                      subtitle: Text('상세 주소 $index'),
                                    );
                                  },
                                ),
                                // 리뷰 탭
                                ListView.builder(
                                  itemCount: 20, // 실제 데이터 수로 대체
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text('사용자 $index'),
                                      subtitle: Text('리뷰 내용 $index'),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
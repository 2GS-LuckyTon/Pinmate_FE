import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListDetailScreen extends StatefulWidget {
  final String title;

  ListDetailScreen({required this.title});

  @override
  _ListDetailScreenState createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  final List<Map<String, dynamic>> savedItems = [
    {
      'title': '경주',
      'locationCount': 32,
      'sharedCount': 122,
      'color': Colors.pink,
      'places': [
        {
          'title': '경주 대릉원',
          'latitude': 35.8352,
          'longitude': 129.2190,
          'description': '경주의 대표적인 고분군',
        },
        {
          'title': '경주 불국사',
          'latitude': 35.7894,
          'longitude': 129.3312,
          'description': '유네스코 세계문화유산',
        },
      ],
    },
    {
      'title': '서울',
      'locationCount': 32,
      'sharedCount': 61,
      'color': Colors.amber,
      'places': [
        {
          'title': '인천대 공학대학',
          'latitude': 37.3757,
          'longitude': 126.6323,
          'description': '공학 분야 교육의 중심지',
        },
        {
          'title': '인천대학교 학산도서관',
          'latitude': 37.3747,
          'longitude': 126.6322,
          'description': '학습과 연구를 위한 도서관',
        },
      ],
    },
  ];

  late Map<String, dynamic> currentList;
  late LatLng initialLocation;
  List<Map<String, dynamic>> placesInCurrentList = [];

  @override
  void initState() {
    super.initState();

    currentList = savedItems.firstWhere(
          (list) => list['title'] == widget.title,
      orElse: () => {
        'title': '기본 위치',
        'places': [],
      },
    );

    placesInCurrentList = List<Map<String, dynamic>>.from(currentList['places'] ?? []);
    initialLocation = placesInCurrentList.isNotEmpty
        ? LatLng(placesInCurrentList[0]['latitude'], placesInCurrentList[0]['longitude'])
        : LatLng(37.3750, 126.6322);

    _initializeMarkers();
  }

  double _getMarkerHue(Color color) {
    if (color == Colors.pink) return BitmapDescriptor.hueRose;
    if (color == Colors.amber) return BitmapDescriptor.hueYellow;
    if (color == Colors.blue) return BitmapDescriptor.hueBlue;
    return BitmapDescriptor.hueRed;
  }

  void _initializeMarkers() {
    Set<Marker> markers = placesInCurrentList.map((place) {
      String description = place['description'] ?? 'No description available';
      if (description.length > 20) {
        description = description.substring(0, 20) + '...';
      }

      return Marker(
        markerId: MarkerId(place['title']),
        position: LatLng(place['latitude'], place['longitude']),
        infoWindow: InfoWindow(title: place['title'], snippet: description),
        icon: BitmapDescriptor.defaultMarkerWithHue(_getMarkerHue(currentList['color'])),
      );
    }).toSet();

    setState(() {
      _markers = markers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.moveCamera(CameraUpdate.newLatLng(initialLocation));
  }

  void _moveToLocation(LatLng location) {
    _mapController.animateCamera(CameraUpdate.newLatLng(location));
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
              target: initialLocation,
              zoom: 17,
            ),
            markers: _markers,
          ),
          // 닫기 버튼
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currentList['title'], style: TextStyle(fontSize: 18)),
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
                            height: 400,
                            child: TabBarView(
                              children: [
                                // 장소 탭
                                ListView.builder(
                                  itemCount: placesInCurrentList.length,
                                  itemBuilder: (context, index) {
                                    final place = placesInCurrentList[index];
                                    String truncatedDescription = place['description'] ?? 'No description available';
                                    if (truncatedDescription.length > 20) {
                                      truncatedDescription = truncatedDescription.substring(0, 20) + '...';
                                    }
                                    return ListTile(
                                      leading: Icon(Icons.location_pin, color: currentList['color']),
                                      title: Text(place['title']),
                                      subtitle: Text(truncatedDescription),
                                      onTap: () {
                                        _moveToLocation(LatLng(place['latitude'], place['longitude']));
                                      },
                                    );
                                  },
                                ),
                                // 리뷰 탭
                                ListView.builder(
                                  itemCount: 20,
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
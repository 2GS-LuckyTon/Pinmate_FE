import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;
import './search_detail_screen.dart';
import './place_save_dialog.dart';
import './select_list_dropdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.9078, 127.7669); // 기본 위치
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _currentLocation;
  bool isDarkMode = false; // 야간 모드 상태를 저장하는 변수
  String? _darkMapStyle; // 야간 모드 스타일

  TextEditingController _titleController = TextEditingController();
  TextEditingController _memoController = TextEditingController();

  bool isBookMarkView = true;

  // 마커를 저장하는 Set
  Set<Marker> _markers = {};

  late List<Map<String, dynamic>> _foodies = [
    {
      "pin_id": "1",
      "listName": "서울",
      "color": 60,
      "name": "정통집",
      "subtitle": "맛집",
      "latitude": 37.5559, // 서울 시청 근처
      "longitude": 126.9730,
    },
    {
      "pin_id": "2",
      "listName": "경주",
      "name": "정돈",
      "color": 20,
      "subtitle": "맛집2",
      "latitude": 35.8327, // 경주 중심부
      "longitude": 129.2279,
    },
    {
      "pin_id": "0",
      "listName": "서울",
      "name": "파이브가이즈",
      "color": 330,
      "subtitle": "햄버거",
      "latitude": 37.5551, // 실제 파이브가이즈 위치
      "longitude": 126.9786,
    },
    {
      "pin_id": "3",
      "listName": "서울",
      "name": "광화문",
      "color": 60,
      "subtitle": "관광지",
      "latitude": 37.5759,
      "longitude": 126.9769,
    },
    {
      "pin_id": "4",
      "listName": "경주",
      "name": "불국사",
      "color": 20,
      "subtitle": "유네스코 세계문화유산",
      "latitude": 35.7894,
      "longitude": 129.3312,
    },
  ];

  void initState() {
    super.initState();
    _loadDarkMapStyle(); // 야간 모드 스타일 불러오기
    _initializeMarkers(); // 마커 초기화
    _fetchFoodies();
  }

  Future<void> _fetchFoodies() async {
    try {
      final response = await http.get(Uri.parse('YOUR_SERVER_URL'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _foodies = data.map((item) =>
          {
            'pin_id': item['pin_id'],
            'listName': item['listName'],
            'color': item['color'],
            'name': item['name'],
            'subtitle': item['subtitle'],
            'latitude': item['latitude'],
            'longitude': item['longitude'],
          }).toList();
          _initializeMarkers(); // 데이터 로드 후 마커 초기화
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching foodies data: $e");
    }
  }

  // 마커 초기화 함수
  void _initializeMarkers() {
    _markers = _foodies.map((e) {
      double hue = e['color'] is int ? (e['color'] as int).toDouble() : 0.0;
      return Marker(
          markerId: MarkerId(e['name'] as String),
          position: LatLng(e['latitude'] as double, e['longitude'] as double),
          infoWindow: InfoWindow(
            title: e['name'] as String,
            snippet: e['subtitle'] as String,
          ),
          icon: e['pin_id'] == "0"
              ? BitmapDescriptor.defaultMarkerWithHue(330)
              : BitmapDescriptor.defaultMarkerWithHue(hue) // 매핑된 색상으로 마커 색상 변경
      );
    }).toSet();
  }

  Future<void> _loadDarkMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/dark.json');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _goToCurrentLocation(); // 현재 위치로 이동
    if (isDarkMode && _darkMapStyle != null) {
      mapController.setMapStyle(_darkMapStyle); // 야간 모드 적용
    }
  }

  Future<void> _getPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _goToCurrentLocation() async {
    await _getPermission(); // 위치 권한 요청
    _currentLocation = await location.getLocation(); // 현재 위치 가져오기
    if (_currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                _currentLocation!.latitude!, _currentLocation!.longitude!),
            zoom: 17.0,
          ),
        ),
      );
    }
  }


  void _toggleMapStyle() {
    setState(() {
      isDarkMode = !isDarkMode;
      mapController.setMapStyle(isDarkMode ? _darkMapStyle : null);
    });
  }

  // 특정 위치에 마커 추가 여부를 묻는 다이얼로그 표시 함수
  void _showMarkerDialog(LatLng tappedPoint) {
    Map<String, dynamic>? selectedList;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('마커 추가'),
          content: Container(
            height: 0.6.sw,
            child: Column(
              children: [
                SelectListDropdown(
                  onListSelected: (list) {
                    selectedList = list; // 선택된 리스트 저장
                    print('선택된 리스트: $selectedList');
                  },
                ),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: '제목',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _memoController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: '한줄 메모',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  maxLength: 35,
                  buildCounter: (BuildContext context,
                      {required int currentLength,
                        required int? maxLength,
                        required bool isFocused}) {
                    return Text(
                      '$currentLength/$maxLength',
                      style: TextStyle(color: Colors.grey),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                print("sdklfjsldf");
                if (selectedList != null) {
                  _addMarker(tappedPoint, _memoController.text,
                      _titleController.text, selectedList!);
                }
                Navigator.of(context).pop();
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 그냥 위치 추가 마크
  void _addMarker(LatLng position, String memo, String title,
      Map<String, dynamic> selectedList) {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId(position.toString()),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                (selectedList['color'] as int).toDouble()),
            infoWindow: InfoWindow(
              title: title,
              snippet: memo, // 추가한 메모를 표시,
            )),
      );
      //더미데이터에 추가
      _foodies.add({
        "name": title,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "color": selectedList['color'],
        "listName": selectedList['title'],
        "subtitle": memo
      });
    });
  }

  //검색 위치 추가 마크
  void _addMarker_search(result) {
    final latitude = result['latitude'];
    final longitude = result['longitude'];
    final memo = result['name'];
    LatLng position = LatLng(latitude, longitude);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          // 파란색 마커 설정
          infoWindow: InfoWindow(
            title: memo,
            onTap: () {
              // 추가 버튼이 있는 다이얼로그를 표시하는 함수 호출
              _showAddButtonDialog(result);
            },
          ),
        ),
      );
    });
  }

  // 다이얼로그를 표시하는 함수
  void _showAddButtonDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlaceSaveDialog(
          result: result,
          onAdd: (selectedList) {
            // 선택된 리스트를 받음
            _addMarker(
              LatLng(result['latitude'], result['longitude']),
              result['address'], // result.address를 사용
              result['name'], // result.name을 제목으로 사용
              selectedList, // 선택된 리스트 추가
            );
          },
        );
      },
    );
  }

  //search 한거 지도로 위치 옮김
  Future<void> _openSearchDetailScreen() async {
    // 현재 지도 위치를 가져옵니다
    final currentPosition = await location.getLocation(); // 현재 위치 가져오기

    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            SearchDetailScreen(
              latitude: currentPosition!.latitude!,
              longitude: currentPosition!.longitude!,
            ),
      ),
    );

    if (result != null) {
      final latitude = result['latitude'];
      final longitude = result['longitude'];

      mapController
          .animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));

      _addMarker_search(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 5.0,
              ),
              markers: isBookMarkView ? _markers : <Marker>{},
              myLocationEnabled: true,
              // 사용자 위치 표시
              myLocationButtonEnabled: false,
              // 사용자 위치
              zoomControlsEnabled: false,
              //onTap: isBookMarkView? _showMarkerDialog : _onMapTap, // 지도 탭 시 다이얼로그 표시
              onTap: _showMarkerDialog // 지도 탭 시 다이얼로그 표시
          ),
        ),
        Positioned(
          right: 10.0,
          top: 100.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                setState(() {
                  isBookMarkView = !isBookMarkView;
                });
              },
              backgroundColor: isBookMarkView ? Colors.grey : Colors.white,
              child: Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50.0,
          right: 10.0,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: _toggleMapStyle,
                  backgroundColor: isDarkMode ? Colors.grey : Colors.white,
                  child: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: isDarkMode ? Colors.amber : Colors.red),
                ),
              ),
              const SizedBox(height: 10), // 버튼 간 간격
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: _goToCurrentLocation,
                  backgroundColor: isDarkMode ? Colors.grey : Colors.white,
                  child: Icon(Icons.my_location, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 5, // 좌측 여백
          right: 5, // 우측 여백
          child: CupertinoButton(
            onPressed: _openSearchDetailScreen,
            child: Container(
              width: 0.95.sw,
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 16),
              // 아이콘과 텍스트의 좌우 간격
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.search,
                          color: isDarkMode ? Colors.white : Colors.grey),
                      // 서치 아이콘 추가
                      const SizedBox(width: 8),
                      // 아이콘과 텍스트 간격
                      Text(
                        '위치 검색',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.red,
                    size: 30,
                  ), // 프로필 아이콘 추가
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

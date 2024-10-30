import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_map_app/main.dart';
import 'package:flutter/services.dart' show rootBundle;
import './search_detail_screen.dart';



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

  void initState() {
    super.initState();
    _loadDarkMapStyle(); // 야간 모드 스타일 불러오기
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
              myLocationEnabled: true, // 사용자 위치 표시
              myLocationButtonEnabled: false, // 사용자 위치
              zoomControlsEnabled: false
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
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: FloatingActionButton(
                mini: true, // 버튼 사이즈를 줄임
                onPressed: _toggleMapStyle,//정정해야야야야야야야
                backgroundColor: isDarkMode ? Colors.grey : Colors.white,
                child: Icon(
                    Icons.star,
                    color: Colors.amber,
                ),
              ),
            ),
          )
          ,
          Positioned(
            bottom: 20.0,
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
                    child: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: isDarkMode ?  Colors.amber : Colors.red
                    ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => SearchDetailScreen()),
                );
              },
              child: Container(
                width: 0.95.sw,
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 16), // 아이콘과 텍스트의 좌우 간격
                decoration: BoxDecoration(
                  color: Colors.white,
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
                        Icon(Icons.search, color: Colors.grey), // 서치 아이콘 추가
                        SizedBox(width: 8), // 아이콘과 텍스트 간격
                        Text(
                          '위치 검색',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.account_circle_outlined, color: Colors.red,size: 30,), // 프로필 아이콘 추가
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }
}


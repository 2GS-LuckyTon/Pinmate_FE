import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> getNearbyPlaces(double lat, double lng, {String? query}) async {
  final String apiKey = 'AIzaSyBbpuoayD7-LKWoLxOzsO5ZN5Zv_AT2teI';
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  // `query`가 존재하면 해당 검색어로 필터링하고, 그렇지 않으면 기본 URL을 사용
  final String url = query != null && query.isNotEmpty
      ? '$baseUrl?location=$lat,$lng&radius=1000&keyword=${Uri.encodeComponent(query)}&key=$apiKey'
      : '$baseUrl?location=$lat,$lng&radius=1000&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // 이름, 주소, 위도, 경도가 포함된 리스트 반환
    return (data['results'] as List).map((place) {
      return {
        'name': place['name'],
        'address': place['vicinity'],
        'latitude': place['geometry']['location']['lat'],
        'longitude': place['geometry']['location']['lng'],
        'phone_number': place['formatted_phone_number'], // 전화번호
        'rating': place['rating'], // 평점
        'opening_hours': place['opening_hours'] != null // 영업시간
            ? place['opening_hours']['open_now']
            : null,
        'place_id': place['place_id'], // 장소 ID
      };
    }).toList();
  } else {
    throw Exception('Failed to load nearby places: ${response.body}');
  }
}

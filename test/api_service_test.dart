import 'package:flutter_test/flutter_test.dart';
import '../lib/services/api_service.dart';

void main() {
  test('Server connection test for /api/user/test', () async {
    final apiService = ApiService();

    await apiService.fetchData();

    // 예상되는 출력이 있는지 수동으로 확인할 수 있습니다.
    // 또는 기대하는 형태의 응답이 있는 경우 이를 기반으로 추가 검증을 작성할 수 있습니다.
  });
}
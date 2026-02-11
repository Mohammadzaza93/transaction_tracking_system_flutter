import '../../../core/network/api_service.dart';

class AuthService {

  Future register(Map<String, dynamic> data) async {
    final res = await ApiService.dio.post('/register', data: data);
    return res.data;
  }

  Future login(String email, String password) async {
    final res = await ApiService.dio.post('/login', data: {
      "email": email,
      "password": password
    });
    return res.data;
  }

  Future logout() async {
    final res = await ApiService.dio.post('/logout');
    return res.data;
  }
}

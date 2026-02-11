import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();

  // حفظ التوكن
  Future<void> saveToken(String token) async {
    await _box.write('token', token);
  }

  // قراءة التوكن
  String? getToken() {
    return _box.read('token');
  }

  // حفظ بيانات المستخدم
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _box.write('user', user);
  }

  // قراءة بيانات المستخدم
  Map<String, dynamic>? getUser() {
    return _box.read('user');
  }

  // قراءة الدور مباشرة
  String? getRole() {
    final user = getUser();
    return user?['role'];
  }

  // حذف كل البيانات (Logout)
  Future<void> clear() async {
    await _box.erase();
  }
}

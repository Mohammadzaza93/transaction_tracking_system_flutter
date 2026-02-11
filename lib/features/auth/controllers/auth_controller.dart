import 'package:get/get.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../../../core/services/storage_service.dart';

class AuthController extends GetxController {
  final AuthRepository repo;
  final StorageService storage = Get.find<StorageService>();

  AuthController(this.repo);

  var loading = false.obs;
  var user = Rxn<UserModel>();
  var token = ''.obs;

  // REGISTER
  Future register({
    required String fullName,
    required String nationalId,
    required String email,
    required String password,
    required String passwordConfirm,
    required int roleId,
  }) async {
    try {
      loading.value = true;

      await repo.register({
        "full_name": fullName,
        "national_id": nationalId,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirm,
        "role_id": roleId,
      });

      Get.snackbar("نجاح", "تم إنشاء الحساب بنجاح");
      Get.offAllNamed('/login');

    } catch (e) {
      Get.snackbar("خطأ", "فشل إنشاء الحساب");
    } finally {
      loading.value = false;
    }
  }

  // LOGIN
  Future login(String email, String password) async {
    try {
      loading.value = true;

      final data = await repo.login(email, password);

      token.value = data['token'];
      user.value = UserModel.fromJson(data['user']);

       storage.saveToken(token.value);
      await storage.saveUser(data['user']);

      // توجيه حسب الدور
      final role = data['user']['role'];

      if (role == "citizen") {
        Get.offAllNamed('/citizen-home');
      } else if (role == "clerk") {
        Get.offAllNamed('/clerk-home');
      } else if (role == "supervisor") {
        Get.offAllNamed('/supervisor-home');
      } else {
        Get.offAllNamed('/login');
      }

    } catch (e) {
      Get.snackbar("خطأ", "بيانات تسجيل الدخول غير صحيحة");
    } finally {
      loading.value = false;
    }
  }

  // LOGOUT
  Future logout() async {
    await repo.logout();

     storage.clear();

    Get.offAllNamed('/login');
  }
}

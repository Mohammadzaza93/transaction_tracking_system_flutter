import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../../../core/services/storage_service.dart';
import 'package:dio/dio.dart';

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

      // عرض رسالة النجاح التي أرسلها السيرفر
      Get.snackbar("نجاح", "تم إنشاء الحساب بنجاح ✅",
          backgroundColor: Colors.green,
          colorText: Colors.white
      );

      Get.offAllNamed('/login');

    } catch (e) {
      String errorMessage = "فشل إنشاء الحساب، يرجى المحاولة لاحقاً";

      // التحقق من وجود خطأ قادم من Dio (Laravel Validation Errors)
      if (e.toString().contains('422')) {
        final response = (e as dynamic).response;
        if (response != null && response.data['errors'] != null) {
          // استخراج أول خطأ موجود في مصفوفة الأخطاء
          var errors = response.data['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.first[0]; // يأخذ أول رسالة خطأ
        } else if (response != null && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
      } else if (e.toString().contains('SocketException')) {
        errorMessage = "تأكد من اتصالك بالإنترنت ومن تشغيل السيرفر";
      }

      Get.snackbar("خطأ في البيانات", errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 4)
      );
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

      final role = data['user']['role'];

      if (role == "citizen") {
        Get.offAllNamed('/citizen-home');
      } else if (role == "clerk") {
        Get.offAllNamed('/clerk-home');
      } else if (role == "supervisor") {
        Get.offAllNamed('/supervisor-home');
      }

    } catch (e) {
      // هنا استخراج رسالة الخطأ من السيرفر
      String errorMessage = "حدث خطأ ما، يرجى المحاولة لاحقاً";

      if (e is DioException) { // إذا كنت تستخدم Dio
        if (e.response != null && e.response?.data != null) {
          // نأخذ حقل 'message' الذي أرسلناه من Laravel
          errorMessage = e.response?.data['message'] ?? errorMessage;
        } else {
          errorMessage = "لا يوجد اتصال بالسيرفر";
        }
      } else {
        errorMessage = e.toString();
      }

      // عرض الرسالة القادمة من السيرفر فعلياً
      Get.snackbar(
        "تنبيه",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );

    } finally {
      loading.value = false;
    }
  }

  // LOGOUT
  Future logout() async {
    try {
      loading.value = true;

      // 1. إعلام السيرفر بتعطيل التوكن
      await repo.logout();

      // 2. مسح البيانات المحلية (Token, User Info)
      await storage.clear();

      // 3. التوجيه لصفحة تسجيل الدخول ومسح التاريخ
      Get.offAllNamed('/login');

    } catch (e) {
      // حتى لو فشل السيرفر، يجب مسح التخزين المحلي وتسجيل الخروج
      await storage.clear();
      Get.offAllNamed('/login');
      print("Logout Error: $e");
    } finally {
      loading.value = false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:transactiontrackingsystemflutter/core/network/api_service.dart';

class HomeController extends GetxController {
  final Dio _dio = ApiService.dio;

  // تعريف المتغيرات التي كانت ناقصة
  var isLoading = false.obs;
  var transactions = <dynamic>[].obs; // RxList
  var stats = <String, dynamic>{}.obs; // RxMap للإحصائيات
  var selectedStatus = 0.obs; // متغير حالة الفلترة (0 = الكل)

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
    fetchStats(); // جلب الإحصائيات عند التشغيل
  }

  // جلب المعاملات
  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final response = await _dio.get("/user/transactions");

      if (response.statusCode == 200) {
        // لتجنب خطأ assignAll، نتأكد من تحويل البيانات إلى List
        List<dynamic> data = response.data;
        transactions.assignAll(data);
      }
    } on DioException catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // جلب الإحصائيات (جديد)
  Future<void> fetchStats() async {
    try {
      final response = await _dio.get("/user-stats");
      if (response.statusCode == 200) {
        stats.value = response.data;
      }
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  // إضافة معاملة جديدة
  Future<void> addTransaction(String type, String reason) async {
    try {
      isLoading.value = true;
      final response = await _dio.post("/transactions", data: {
        "transaction_type": type,
        "reason": reason,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back(); // إغلاق الدايلوج
        fetchTransactions(); // تحديث القائمة
        fetchStats(); // تحديث الأرقام العلوية
        Get.snackbar("تم الإرسال", "معاملتك الآن قيد الدراسة",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } on DioException catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(DioException e) {
    String message = "حدث خطأ في الاتصال";
    if (e.response?.statusCode == 422) {
      message = e.response?.data['message'] ?? "بيانات غير صالحة";
    }
    Get.snackbar("تنبيه", message,
        backgroundColor: Colors.redAccent, colorText: Colors.white);
  }
}
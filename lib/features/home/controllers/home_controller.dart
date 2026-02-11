import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:transactiontrackingsystemflutter/core/network/api_service.dart';

class HomeController extends GetxController {
  // استخدام الـ dio المعرف في الـ ApiService
  final Dio _dio = ApiService.dio;

  var isLoading = false.obs;
  var transactions = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  // جلب المعاملات
  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      // سيقوم الـ Interceptor تلقائياً بإضافة الـ Token هنا
      final response = await _dio.get("/transactions");

      if (response.statusCode == 200) {
        transactions.assignAll(response.data); // تحديث القائمة بكفاءة
      }
    } on DioException catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // إضافة معاملة جديدة
  // إضافة معاملة جديدة - النسخة المصححة
  // داخل HomeController.dart

  Future<void> addTransaction(String type, String reason) async {
    try {
      isLoading.value = true;

      // إرسال البيانات للسيرفر
      final response = await _dio.post("/transactions", data: {
        "transaction_type": type, // الحقل المطلوب في قاعدة البيانات
        "reason": reason,         // الحقل المطلوب في قاعدة البيانات
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back(); // إغلاق النافذة بعد النجاح
        fetchTransactions(); // تحديث القائمة فوراً
        Get.snackbar("تم الإرسال", "معاملتك الآن قيد الدراسة",
            backgroundColor: Colors.green, colorText: Colors.white);
      }
    } on DioException catch (e) {
      // طباعة الخطأ لمعرفة ما إذا كان السيرفر لا يزال يرفض شيئاً ما
      print("Server Error: ${e.response?.data}");
      Get.snackbar("خطأ", "فشل إرسال المعاملة، حاول مجدداً");
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

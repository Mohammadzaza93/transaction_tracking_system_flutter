import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../repositories/transaction_repository.dart';

class TransactionController extends GetxController {
  final TransactionRepository _repository;
  TransactionController(this._repository);

  var isLoading = false.obs;
  var transactions = <dynamic>[].obs;
  var stats = <String, dynamic>{}.obs;
  var selectedStatus = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      // جلب البيانات معاً لتقليل زمن الانتظار
      final results = await Future.wait([
        _repository.getTransactions(),
        _repository.getStats(),
      ]);

      transactions.assignAll(results[0] as List);
      stats.value = results[1] as Map<String, dynamic>;
    } on DioException catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTransaction(String type, String reason, int copies) async {
    try {
      isLoading.value = true;
      // تمرير الـ copies للمستودع (Repository)
      await _repository.createTransaction(type, reason, copies);
      Get.back();
      refreshData();
      Get.snackbar("نجاح", "تم إرسال الطلب بنجاح");
    } on DioException catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(DioException e) {
    String msg = e.response?.data['message'] ?? "خطأ في الاتصال";
    Get.snackbar("تنبيه", msg, snackPosition: SnackPosition.BOTTOM);
  }
}
import 'package:dio/dio.dart';
import '../../../../core/network/api_service.dart';

class TransactionService {
  final Dio _dio = ApiService.dio;

  // جلب المعاملات
  Future<Response> fetchTransactions() => _dio.get("/user/transactions");

  // جلب الإحصائيات
  Future<Response> fetchStats() => _dio.get("/user-stats");

  // إضافة معاملة
  Future<Response> addTransaction(String type, String reason, int copies) =>
      _dio.post("/transactions", data: {
        "transaction_type": type,
        "reason": reason,
        "copies_count": copies, // المفتاح الذي ينتظره الـ Backend
      });
}
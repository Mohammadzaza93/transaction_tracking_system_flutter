import '../services/transaction_service.dart';

class TransactionRepository {
  final TransactionService _service;

  TransactionRepository(this._service);

  Future<List<dynamic>> getTransactions() async {
    final response = await _service.fetchTransactions();
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getStats() async {
    final response = await _service.fetchStats();
    return response.data as Map<String, dynamic>;
  }

  Future<void> createTransaction(String type, String reason, int copies) async {
    await _service.addTransaction(type, reason, copies);
  }
}
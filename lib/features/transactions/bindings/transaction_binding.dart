import 'package:get/get.dart';
import '../services/transaction_service.dart';
import '../repositories/transaction_repository.dart';
import '../controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionService());
    Get.lazyPut(() => TransactionRepository(Get.find<TransactionService>()));
    Get.lazyPut(() => TransactionController(Get.find<TransactionRepository>()));
  }
}
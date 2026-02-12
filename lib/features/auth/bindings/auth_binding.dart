import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../repositories/auth_repository.dart';
import '../services/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Service
    Get.lazyPut<AuthService>(() => AuthService());

    // Repository
    Get.lazyPut<AuthRepository>(
            () => AuthRepository(Get.find<AuthService>())
    );

    // Controller
    Get.lazyPut<AuthController>(
            () => AuthController(Get.find<AuthRepository>())
    );
  }
}

import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/auth/controllers/auth_controller.dart';
import 'package:transactiontrackingsystemflutter/features/auth/repositories/auth_repository.dart';
import 'package:transactiontrackingsystemflutter/features/auth/services/auth_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: true تجعل المتحكم يبقى في الذاكرة طالما الصفحة نشطة
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
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

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: true تجعل المتحكم يبقى في الذاكرة طالما الصفحة نشطة
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
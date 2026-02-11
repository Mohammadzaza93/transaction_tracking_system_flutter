import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final storage = Get.find<StorageService>();

    final token = storage.getToken();
    final role = storage.getRole();

    if (token == null) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      if (role == "citizen") {
        Get.offAllNamed(AppRoutes.citizenHome);
      } else if (role == "clerk") {
        Get.offAllNamed(AppRoutes.clerkHome);
      } else {
        Get.offAllNamed(AppRoutes.supervisorHome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

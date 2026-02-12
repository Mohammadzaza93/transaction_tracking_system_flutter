import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/home/bindings/home_binding.dart';
import 'package:transactiontrackingsystemflutter/features/home/screens/citizen_home_screen.dart';
import 'package:transactiontrackingsystemflutter/features/home/screens/clerk_home_screen.dart';
import 'package:transactiontrackingsystemflutter/features/home/screens/supervisor_home_screen.dart';

import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';

import '../../features/splash/screens/splash_screen.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [

    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.citizenHome,
      page: () => CitizenHomeScreen(),
      binding: HomeBinding(),
    ),


    GetPage(
      name: AppRoutes.clerkHome,
      page: () => ClerkHomeScreen(),
    ),

    GetPage(
      name: AppRoutes.supervisorHome,
      page: () => SupervisorHomeScreen(),
    ),
  ];
}

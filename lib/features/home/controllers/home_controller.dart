import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:transactiontrackingsystemflutter/core/network/api_service.dart';

class HomeController extends GetxController {
  final Dio _dio = ApiService.dio;

  // تعريف المتغيرات التي كانت ناقصة
  var isLoading = false.obs;
  var transactions = <dynamic>[].obs; // RxList
  var stats = <String, dynamic>{}.obs; // RxMap للإحصائيات
  var selectedStatus = 0.obs; // متغير حالة الفلترة (0 = الكل)

  @override
  void onInit() {
    super.onInit();

  }

  // جلب المعاملات

}
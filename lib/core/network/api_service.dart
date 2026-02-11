import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      headers: {
        "Accept": "application/json",
      },
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final storage = Get.find<StorageService>();
        final token = storage.getToken();

        if (token != null) {
          options.headers['Authorization'] = "Bearer $token";
        }

        return handler.next(options);
      },
    ),
  );
}

import 'dart:io';
import 'package:dio/dio.dart';

class DocumentsRemoteSource {
  final Dio _dio;
  DocumentsRemoteSource(this._dio);

  Future<void> uploadDocuments({
    required int transactionId,
    required List<File> files,
  }) async {
    try {
      // تجهيز الملفات كقائمة من MultipartFile
      List<MultipartFile> multipartFiles = [];
      for (var file in files) {
        multipartFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

      // إرسال البيانات - تأكد من استخدام المفتاح 'documents[]' بالأقواس
      FormData formData = FormData.fromMap({
        "transaction_id": transactionId,
        "documents[]": multipartFiles,
      });

      final response = await _dio.post(
        '/documents/upload',
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("فشل الرفع: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      // هذا السطر سيطبع لك السبب الحقيقي القادم من Laravel في الـ Console
      print("خطأ السيرفر: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "فشل الاتصال بالسيرفر");
    }
  }
}
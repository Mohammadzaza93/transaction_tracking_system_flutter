import 'dart:io';
import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/documents/repository/documents_repository.dart';

class DocumentController extends GetxController {
  final DocumentsRepository repository;

  DocumentController(this.repository);

  var selectedFiles = <File>[].obs;
  var isUploading = false.obs;

  void addFiles(List<File> files) {
    selectedFiles.addAll(files);
  }

  void removeFile(File file) {
    selectedFiles.remove(file);
  }

  Future<void> upload(int transactionId) async {
    try {
      isUploading.value = true;

      await repository.uploadDocuments(
        transactionId: transactionId,
        files: selectedFiles,
      );

      Get.snackbar("نجاح", "تم رفع الملفات بنجاح");
      selectedFiles.clear();
    } catch (e) {
      Get.snackbar("خطأ", "فشل رفع الملفات");
    } finally {
      isUploading.value = false;
    }
  }
}
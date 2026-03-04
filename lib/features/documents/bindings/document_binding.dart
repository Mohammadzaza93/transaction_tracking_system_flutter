import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:transactiontrackingsystemflutter/features/documents/repository/documents_repository.dart';
import 'package:transactiontrackingsystemflutter/features/documents/repository/documents_repository_impl.dart';
import '../../../core/network/api_service.dart';
import '../controllers/document_controller.dart';
import '../data/sources/documents_remote_source.dart';

class DocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DocumentsRemoteSource(ApiService.dio));

    Get.lazyPut<DocumentsRepository>(
          () => DocumentsRepositoryImpl(Get.find()),
    );

    Get.lazyPut(
          () => DocumentController(Get.find()),
    );
  }
}
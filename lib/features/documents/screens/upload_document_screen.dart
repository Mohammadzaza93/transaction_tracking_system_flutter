import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/documents/widgets/document_upload_widget.dart';
import '../controllers/document_controller.dart';

class UploadDocumentsScreen extends StatelessWidget {
  final int transactionId;

  const UploadDocumentsScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("رفع مستندات المعاملة"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: DocumentUploadWidget(
          transactionId: transactionId,
        ),
      ),
    );
  }
}
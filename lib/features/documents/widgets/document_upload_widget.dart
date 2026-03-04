import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/document_controller.dart';

class DocumentUploadWidget extends StatelessWidget {
  final int transactionId;

  const DocumentUploadWidget({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    // الوصول للـ Controller الذي تم حقنه عبر Binding
    final controller = Get.find<DocumentController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // منطقة اختيار الملفات
        InkWell(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true, // ميزة اختيار أكثر من ملف حسب كود الـ Controller
              type: FileType.custom,
              allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
            );

            if (result != null) {
              List<File> files = result.paths.map((path) => File(path!)).toList();
              controller.addFiles(files);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.blue[900]),
                const SizedBox(height: 10),
                const Text("اضغط هنا لاختيار المستندات",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("(PDF, JPG, PNG)", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // عرض قائمة الملفات المختارة
        Expanded(
          child: Obx(() => controller.selectedFiles.isEmpty
              ? const Center(child: Text("لم يتم اختيار ملفات بعد"))
              : ListView.builder(
            itemCount: controller.selectedFiles.length,
            itemBuilder: (context, index) {
              final file = controller.selectedFiles[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.insert_drive_file, color: Colors.blue),
                  title: Text(file.path.split('/').last,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.removeFile(file),
                  ),
                ),
              );
            },
          )),
        ),

        // زر الرفع النهائي
        Obx(() => SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: (controller.isUploading.value || controller.selectedFiles.isEmpty)
                ? null
                : () => controller.upload(transactionId),
            child: controller.isUploading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("رفع المستندات الآن",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        )),
      ],
    );
  }
}
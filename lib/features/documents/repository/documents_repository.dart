import 'dart:io';

abstract class DocumentsRepository {
  Future<void> uploadDocuments({
    required int transactionId,
    required List<File> files,
  });
}
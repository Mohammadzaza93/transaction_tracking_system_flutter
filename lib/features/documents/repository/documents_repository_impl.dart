import 'dart:io';

import 'package:transactiontrackingsystemflutter/features/documents/data/sources/documents_remote_source.dart';
import 'package:transactiontrackingsystemflutter/features/documents/repository/documents_repository.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final DocumentsRemoteSource remoteSource;

  DocumentsRepositoryImpl(this.remoteSource);

  @override
  Future<void> uploadDocuments({
    required int transactionId,
    required List<File> files,
  }) async {
    await remoteSource.uploadDocuments(
      transactionId: transactionId,
      files: files,
    );
  }
}
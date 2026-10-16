import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../api/api_exception.dart';

/// Opens a PDF in the phone's PDF app WITHOUT putting it in the shared Downloads folder: the
/// file is saved in this app's private cache and shared with the viewer for reading only.
/// Cached copies older than an hour are removed each time. Swapped for a fake in tests.
abstract class DocumentOpener {
  /// False when no app on the phone can open it.
  Future<bool> openPdf({required String url, required String documentId});
}

class DevicePdfOpener implements DocumentOpener {
  DevicePdfOpener(this._http);

  final Dio _http;

  @override
  Future<bool> openPdf({required String url, required String documentId}) async {
    final dir = Directory('${(await getTemporaryDirectory()).path}/documents');
    await dir.create(recursive: true);
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    for (final old in dir.listSync().whereType<File>()) {
      if (old.lastModifiedSync().isBefore(cutoff)) old.deleteSync();
    }
    final path = '${dir.path}/$documentId.pdf';
    try {
      await _http.download(url, path);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
    final result = await OpenFilex.open(path, type: 'application/pdf');
    return result.type == ResultType.done;
  }
}

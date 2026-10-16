import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api_exception.dart';
import '../config/app_config.dart';

/// Where a file comes from: camera (back or front), gallery or a PDF.
enum PickSource { camera, frontCamera, gallery, pdf }

class PickedFile {
  const PickedFile({required this.bytes, required this.mime});

  final Uint8List bytes;
  final String mime;
}

/// Camera, gallery and PDF picker. Swapped for a fake in tests.
abstract class FilePickerService {
  Future<PickedFile?> pick(PickSource source);
}

class DeviceFilePicker implements FilePickerService {
  @override
  Future<PickedFile?> pick(PickSource source) async {
    if (source == PickSource.pdf) {
      final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['pdf']);
      if (file == null) return null;
      return PickedFile(bytes: await file.readAsBytes(), mime: 'application/pdf');
    }
    // Photos are re-encoded as JPEG (smaller uploads; phones may save HEIC).
    final image = await ImagePicker().pickImage(
      source: source == PickSource.gallery ? ImageSource.gallery : ImageSource.camera,
      preferredCameraDevice: source == PickSource.frontCamera ? CameraDevice.front : CameraDevice.rear,
      imageQuality: 80,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    if (image == null) return null;
    final lower = image.name.toLowerCase();
    final mime = lower.endsWith('.png') ? 'image/png' : 'image/jpeg';
    return PickedFile(bytes: await image.readAsBytes(), mime: mime);
  }
}

/// "/v1/files/…" from the API (local dev storage) → a full URL; S3 links are already full.
String fileUrl(AppConfig config, String url) => url.startsWith('/') ? '${config.apiBaseUrl}$url' : url;

/// Step 2 of every upload (ARCHITECTURE §6.8, v2.31): a multipart POST to the URL the API
/// handed out, its form fields first (the signed policy, unchanged) and the file last as
/// `file`. The storage itself refuses a file that is too big or of another type.
/// [http] is a plain client (no auth header: the upload is signed).
Future<void> sendUpload(
  dio.Dio http,
  AppConfig config,
  String uploadUrl,
  Map<String, String> fields,
  PickedFile file, {
  void Function(double progress)? onProgress,
}) async {
  try {
    final form = dio.FormData()
      ..fields.addAll(fields.entries)
      ..files.add(
        MapEntry(
          'file',
          dio.MultipartFile.fromBytes(file.bytes, filename: 'upload', contentType: dio.DioMediaType.parse(file.mime)),
        ),
      );
    await http.post<void>(
      fileUrl(config, uploadUrl),
      data: form,
      onSendProgress: onProgress == null
          ? null
          : (sent, total) => onProgress(total <= 0 ? 0 : (sent / total).clamp(0, 1).toDouble()),
    );
  } on dio.DioException catch (e) {
    throw uploadError(e);
  }
}

/// S3 refuses in XML, not in WellWish's JSON: its answers become the codes the apps already
/// say in their language (the local stand-in answers JSON with the same codes).
ApiException uploadError(dio.DioException e) {
  final status = e.response?.statusCode;
  final data = e.response?.data;
  if (data is Map) return ApiException.fromDio(e);
  final text = '${data ?? ''}';
  if (status == 413 || text.contains('EntityTooLarge')) {
    return ApiException(code: 'FILE_TOO_LARGE', message: '', statusCode: status);
  }
  if (status == 403) {
    // the signed policy ran out (or was refused): ask for a new upload link
    return ApiException(code: 'UPLOAD_EXPIRED', message: '', statusCode: status);
  }
  return ApiException.fromDio(e);
}

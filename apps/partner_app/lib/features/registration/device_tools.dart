import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';

// Camera, gallery, PDF, location and the upload PUT live in ww_core (shared with the patient app).
export 'package:ww_core/ww_core.dart'
    show FilePickerService, LocationProblem, LocationResult, LocationService, PickSource, PickedFile, fileUrl;

final filePickerProvider = Provider<FilePickerService>((ref) => DeviceFilePicker());

final locationServiceProvider = Provider<LocationService>((ref) => DeviceLocation());

/// Upload flow (ARCHITECTURE §6.8): ask for an upload URL, PUT the bytes there, keep the key.
class Uploader {
  Uploader(this._api, this._config, this._http);

  final PartnerApi _api;
  final AppConfig _config;
  final dio.Dio _http;

  Future<String> upload(PartnerUploadUrlInPurposeEnum purpose, PickedFile file) async {
    final ticket = (await _api.partnerKycUploadUrl(
      partnerUploadUrlIn: PartnerUploadUrlIn(purpose: purpose, mime: file.mime, sizeBytes: file.bytes.length),
    )).data!;
    await sendUpload(_http, _config, ticket.uploadUrl, ticket.uploadFields, file);
    return ticket.fileKey;
  }
}

/// Plain client for uploads (no auth header: the URL itself is signed).
final uploadHttpProvider = Provider<dio.Dio>((ref) => dio.Dio());

final uploaderProvider = Provider<Uploader>(
  (ref) => Uploader(ref.watch(partnerApiProvider), ref.watch(appConfigProvider), ref.watch(uploadHttpProvider)),
);

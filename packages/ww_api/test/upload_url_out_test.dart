import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for UploadUrlOut
void main() {
  final UploadUrlOut? instance = /* UploadUrlOut(...) */ null;
  // TODO add properties to the entity

  group(UploadUrlOut, () {
    // Send this with the form after uploading
    // String fileKey
    test('to test the property `fileKey`', () async {
      // TODO
    });

    // POST the file here as multipart/form-data: every upload field first, then the file as `file` (/path = on this API). The storage refuses a bigger file.
    // String uploadUrl
    test('to test the property `uploadUrl`', () async {
      // TODO
    });

    // Form fields to send before the file, unchanged (the signed policy)
    // Map<String, String> uploadFields
    test('to test the property `uploadFields`', () async {
      // TODO
    });

    // String mime
    test('to test the property `mime`', () async {
      // TODO
    });

    // int maxBytes
    test('to test the property `maxBytes`', () async {
      // TODO
    });

  });
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ww_core/ww_core.dart';

/// Keeps the request and its body, answers [status] with [body] ([xml]: as S3 answers).
class _Storage implements HttpClientAdapter {
  _Storage({this.status = 204, this.body = '', this.xml = false});

  final int status;
  final String body;
  final bool xml;
  RequestOptions? request;
  String sent = '';

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancel) async {
    request = options;
    final bytes = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
    }
    sent = latin1.decode(bytes);
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [xml ? 'application/xml' : Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

final _config = AppConfig.forFlavor(Flavor.dev);
final _png = PickedFile(bytes: Uint8List.fromList([0x89, 0x50, 0x4e, 0x47, 1, 2, 3]), mime: 'image/png');

void main() {
  group('sendUpload (ARCHITECTURE §6.8, v2.31: a presigned POST)', () {
    test('posts the signed fields first and the file last, without a login header', () async {
      final storage = _Storage();
      final http = Dio()..httpClientAdapter = storage;
      await sendUpload(http, _config, '/v1/files/upload/tok', {
        'key': 'f/abc.png',
        'Content-Type': 'image/png',
        'policy': 'p0l1cy',
        'x-amz-signature': 's1g',
      }, _png);

      final request = storage.request!;
      expect(request.method, 'POST');
      expect(request.uri.toString(), '${_config.apiBaseUrl}/v1/files/upload/tok');
      expect(request.headers.keys.map((k) => k.toLowerCase()), isNot(contains('authorization')));
      expect(request.headers[Headers.contentTypeHeader].toString(), startsWith('multipart/form-data'));
      final sent = storage.sent;
      final order = [
        'name="key"',
        'name="Content-Type"',
        'name="policy"',
        'name="x-amz-signature"',
        'name="file"',
      ].map(sent.indexOf).toList();
      expect(order.every((i) => i >= 0), isTrue, reason: sent);
      expect(order, [...order]..sort(), reason: 'S3 ignores fields after the file');
      final file = sent.substring(sent.indexOf('name="file"'));
      expect(file, contains('filename="upload"'));
      expect(file, contains('content-type: image/png'));
      expect(file, contains(latin1.decode(_png.bytes)));
    });

    Future<ApiException> refusal(_Storage storage) async {
      try {
        await sendUpload(Dio()..httpClientAdapter = storage, _config, 'https://bucket.s3.amazonaws.com/', {}, _png);
      } on ApiException catch (e) {
        return e;
      }
      fail('the upload should have been refused');
    }

    test("S3's XML refusals become the codes the apps translate", () async {
      const tooLarge = '<?xml version="1.0"?><Error><Code>EntityTooLarge</Code></Error>';
      const denied = '<?xml version="1.0"?><Error><Code>AccessDenied</Code><Message>expired</Message></Error>';
      expect((await refusal(_Storage(status: 400, body: tooLarge, xml: true))).code, 'FILE_TOO_LARGE');
      expect((await refusal(_Storage(status: 403, body: denied, xml: true))).code, 'UPLOAD_EXPIRED');
      // the local stand-in answers in WellWish's JSON
      final json = jsonEncode({
        'error': {'code': 'UPLOAD_EXPIRED', 'message': 'expired', 'details': <String, Object>{}},
      });
      expect((await refusal(_Storage(status: 403, body: json))).code, 'UPLOAD_EXPIRED');
    });
  });

  test('a public page opens in the app language, other query kept', () {
    expect(
      publicPageUri('https://wellwish.in/legal/privacy', 'hi').toString(),
      'https://wellwish.in/legal/privacy?l=hi',
    );
    expect(publicPageUri('http://10.0.2.2:8000/legal/terms?l=en&x=1', 'or').queryParameters, {'l': 'or', 'x': '1'});
  });
}

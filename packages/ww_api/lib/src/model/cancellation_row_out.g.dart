// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CancellationRowOutCWProxy {
  CancellationRowOut kind(String kind);

  CancellationRowOut bookingId(String bookingId);

  CancellationRowOut code(String code);

  CancellationRowOut visitDate(DateTime visitDate);

  CancellationRowOut service(String service);

  CancellationRowOut at(DateTime at);

  CancellationRowOut by(String by);

  CancellationRowOut reason(String reason);

  CancellationRowOut refundPercent(int? refundPercent);

  CancellationRowOut feePaidPaise(int feePaidPaise);

  CancellationRowOut refundedPaise(int refundedPaise);

  CancellationRowOut refundStatus(String refundStatus);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancellationRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancellationRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  CancellationRowOut call({
    String kind,
    String bookingId,
    String code,
    DateTime visitDate,
    String service,
    DateTime at,
    String by,
    String reason,
    int? refundPercent,
    int feePaidPaise,
    int refundedPaise,
    String refundStatus,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCancellationRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCancellationRowOut.copyWith.fieldName(...)`
class _$CancellationRowOutCWProxyImpl implements _$CancellationRowOutCWProxy {
  const _$CancellationRowOutCWProxyImpl(this._value);

  final CancellationRowOut _value;

  @override
  CancellationRowOut kind(String kind) => this(kind: kind);

  @override
  CancellationRowOut bookingId(String bookingId) => this(bookingId: bookingId);

  @override
  CancellationRowOut code(String code) => this(code: code);

  @override
  CancellationRowOut visitDate(DateTime visitDate) =>
      this(visitDate: visitDate);

  @override
  CancellationRowOut service(String service) => this(service: service);

  @override
  CancellationRowOut at(DateTime at) => this(at: at);

  @override
  CancellationRowOut by(String by) => this(by: by);

  @override
  CancellationRowOut reason(String reason) => this(reason: reason);

  @override
  CancellationRowOut refundPercent(int? refundPercent) =>
      this(refundPercent: refundPercent);

  @override
  CancellationRowOut feePaidPaise(int feePaidPaise) =>
      this(feePaidPaise: feePaidPaise);

  @override
  CancellationRowOut refundedPaise(int refundedPaise) =>
      this(refundedPaise: refundedPaise);

  @override
  CancellationRowOut refundStatus(String refundStatus) =>
      this(refundStatus: refundStatus);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancellationRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancellationRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  CancellationRowOut call({
    Object? kind = const $CopyWithPlaceholder(),
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? visitDate = const $CopyWithPlaceholder(),
    Object? service = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
    Object? by = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? refundPercent = const $CopyWithPlaceholder(),
    Object? feePaidPaise = const $CopyWithPlaceholder(),
    Object? refundedPaise = const $CopyWithPlaceholder(),
    Object? refundStatus = const $CopyWithPlaceholder(),
  }) {
    return CancellationRowOut(
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as String,
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      visitDate: visitDate == const $CopyWithPlaceholder()
          ? _value.visitDate
          // ignore: cast_nullable_to_non_nullable
          : visitDate as DateTime,
      service: service == const $CopyWithPlaceholder()
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as String,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      by: by == const $CopyWithPlaceholder()
          ? _value.by
          // ignore: cast_nullable_to_non_nullable
          : by as String,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      refundPercent: refundPercent == const $CopyWithPlaceholder()
          ? _value.refundPercent
          // ignore: cast_nullable_to_non_nullable
          : refundPercent as int?,
      feePaidPaise: feePaidPaise == const $CopyWithPlaceholder()
          ? _value.feePaidPaise
          // ignore: cast_nullable_to_non_nullable
          : feePaidPaise as int,
      refundedPaise: refundedPaise == const $CopyWithPlaceholder()
          ? _value.refundedPaise
          // ignore: cast_nullable_to_non_nullable
          : refundedPaise as int,
      refundStatus: refundStatus == const $CopyWithPlaceholder()
          ? _value.refundStatus
          // ignore: cast_nullable_to_non_nullable
          : refundStatus as String,
    );
  }
}

extension $CancellationRowOutCopyWith on CancellationRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfCancellationRowOut.copyWith(...)` or like so:`instanceOfCancellationRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CancellationRowOutCWProxy get copyWith =>
      _$CancellationRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancellationRowOut _$CancellationRowOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CancellationRowOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'kind',
      'bookingId',
      'code',
      'visitDate',
      'service',
      'at',
      'by',
      'reason',
      'feePaidPaise',
      'refundedPaise',
      'refundStatus',
    ],
  );
  final val = CancellationRowOut(
    kind: $checkedConvert('kind', (v) => v as String),
    bookingId: $checkedConvert('bookingId', (v) => v as String),
    code: $checkedConvert('code', (v) => v as String),
    visitDate: $checkedConvert('visitDate', (v) => DateTime.parse(v as String)),
    service: $checkedConvert('service', (v) => v as String),
    at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
    by: $checkedConvert('by', (v) => v as String),
    reason: $checkedConvert('reason', (v) => v as String),
    refundPercent: $checkedConvert(
      'refundPercent',
      (v) => (v as num?)?.toInt(),
    ),
    feePaidPaise: $checkedConvert('feePaidPaise', (v) => (v as num).toInt()),
    refundedPaise: $checkedConvert('refundedPaise', (v) => (v as num).toInt()),
    refundStatus: $checkedConvert('refundStatus', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$CancellationRowOutToJson(CancellationRowOut instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'bookingId': instance.bookingId,
      'code': instance.code,
      'visitDate': instance.visitDate.toIso8601String(),
      'service': instance.service,
      'at': instance.at.toIso8601String(),
      'by': instance.by,
      'reason': instance.reason,
      'refundPercent': ?instance.refundPercent,
      'feePaidPaise': instance.feePaidPaise,
      'refundedPaise': instance.refundedPaise,
      'refundStatus': instance.refundStatus,
    };

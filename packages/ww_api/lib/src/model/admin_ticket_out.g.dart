// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminTicketOutCWProxy {
  AdminTicketOut id(String id);

  AdminTicketOut text(String text);

  AdminTicketOut status(String status);

  AdminTicketOut replies(List<TicketReplyOut> replies);

  AdminTicketOut createdAt(DateTime createdAt);

  AdminTicketOut bookingId(String? bookingId);

  AdminTicketOut code(String code);

  AdminTicketOut patientName(String patientName);

  AdminTicketOut patientPhone(String patientPhone);

  AdminTicketOut partnerName(String partnerName);

  AdminTicketOut closedAt(DateTime? closedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminTicketOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminTicketOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminTicketOut call({
    String id,
    String text,
    String status,
    List<TicketReplyOut> replies,
    DateTime createdAt,
    String? bookingId,
    String code,
    String patientName,
    String patientPhone,
    String partnerName,
    DateTime? closedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminTicketOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminTicketOut.copyWith.fieldName(...)`
class _$AdminTicketOutCWProxyImpl implements _$AdminTicketOutCWProxy {
  const _$AdminTicketOutCWProxyImpl(this._value);

  final AdminTicketOut _value;

  @override
  AdminTicketOut id(String id) => this(id: id);

  @override
  AdminTicketOut text(String text) => this(text: text);

  @override
  AdminTicketOut status(String status) => this(status: status);

  @override
  AdminTicketOut replies(List<TicketReplyOut> replies) =>
      this(replies: replies);

  @override
  AdminTicketOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AdminTicketOut bookingId(String? bookingId) => this(bookingId: bookingId);

  @override
  AdminTicketOut code(String code) => this(code: code);

  @override
  AdminTicketOut patientName(String patientName) =>
      this(patientName: patientName);

  @override
  AdminTicketOut patientPhone(String patientPhone) =>
      this(patientPhone: patientPhone);

  @override
  AdminTicketOut partnerName(String partnerName) =>
      this(partnerName: partnerName);

  @override
  AdminTicketOut closedAt(DateTime? closedAt) => this(closedAt: closedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminTicketOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminTicketOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminTicketOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? replies = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? patientName = const $CopyWithPlaceholder(),
    Object? patientPhone = const $CopyWithPlaceholder(),
    Object? partnerName = const $CopyWithPlaceholder(),
    Object? closedAt = const $CopyWithPlaceholder(),
  }) {
    return AdminTicketOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      replies: replies == const $CopyWithPlaceholder()
          ? _value.replies
          // ignore: cast_nullable_to_non_nullable
          : replies as List<TicketReplyOut>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String?,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      patientName: patientName == const $CopyWithPlaceholder()
          ? _value.patientName
          // ignore: cast_nullable_to_non_nullable
          : patientName as String,
      patientPhone: patientPhone == const $CopyWithPlaceholder()
          ? _value.patientPhone
          // ignore: cast_nullable_to_non_nullable
          : patientPhone as String,
      partnerName: partnerName == const $CopyWithPlaceholder()
          ? _value.partnerName
          // ignore: cast_nullable_to_non_nullable
          : partnerName as String,
      closedAt: closedAt == const $CopyWithPlaceholder()
          ? _value.closedAt
          // ignore: cast_nullable_to_non_nullable
          : closedAt as DateTime?,
    );
  }
}

extension $AdminTicketOutCopyWith on AdminTicketOut {
  /// Returns a callable class that can be used as follows: `instanceOfAdminTicketOut.copyWith(...)` or like so:`instanceOfAdminTicketOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminTicketOutCWProxy get copyWith => _$AdminTicketOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminTicketOut _$AdminTicketOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminTicketOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'text',
          'status',
          'replies',
          'createdAt',
          'bookingId',
          'code',
          'patientName',
          'patientPhone',
          'partnerName',
          'closedAt',
        ],
      );
      final val = AdminTicketOut(
        id: $checkedConvert('id', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        replies: $checkedConvert(
          'replies',
          (v) => (v as List<dynamic>)
              .map((e) => TicketReplyOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        bookingId: $checkedConvert('bookingId', (v) => v as String?),
        code: $checkedConvert('code', (v) => v as String),
        patientName: $checkedConvert('patientName', (v) => v as String),
        patientPhone: $checkedConvert('patientPhone', (v) => v as String),
        partnerName: $checkedConvert('partnerName', (v) => v as String),
        closedAt: $checkedConvert(
          'closedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminTicketOutToJson(AdminTicketOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'status': instance.status,
      'replies': instance.replies.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'bookingId': instance.bookingId,
      'code': instance.code,
      'patientName': instance.patientName,
      'patientPhone': instance.patientPhone,
      'partnerName': instance.partnerName,
      'closedAt': instance.closedAt?.toIso8601String(),
    };

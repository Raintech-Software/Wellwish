// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OfferOutCWProxy {
  OfferOut id(String id);

  OfferOut kind(String kind);

  OfferOut partnerId(String partnerId);

  OfferOut partnerName(String partnerName);

  OfferOut phone(String phone);

  OfferOut alternatePhone(String alternatePhone);

  OfferOut assignedBy(String assignedBy);

  OfferOut sentAt(DateTime sentAt);

  OfferOut timeoutAt(DateTime timeoutAt);

  OfferOut response(String response);

  OfferOut respondedAt(DateTime? respondedAt);

  OfferOut declineReason(String declineReason);

  OfferOut declineNote(String declineNote);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferOut(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferOut call({
    String id,
    String kind,
    String partnerId,
    String partnerName,
    String phone,
    String alternatePhone,
    String assignedBy,
    DateTime sentAt,
    DateTime timeoutAt,
    String response,
    DateTime? respondedAt,
    String declineReason,
    String declineNote,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOfferOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOfferOut.copyWith.fieldName(...)`
class _$OfferOutCWProxyImpl implements _$OfferOutCWProxy {
  const _$OfferOutCWProxyImpl(this._value);

  final OfferOut _value;

  @override
  OfferOut id(String id) => this(id: id);

  @override
  OfferOut kind(String kind) => this(kind: kind);

  @override
  OfferOut partnerId(String partnerId) => this(partnerId: partnerId);

  @override
  OfferOut partnerName(String partnerName) => this(partnerName: partnerName);

  @override
  OfferOut phone(String phone) => this(phone: phone);

  @override
  OfferOut alternatePhone(String alternatePhone) =>
      this(alternatePhone: alternatePhone);

  @override
  OfferOut assignedBy(String assignedBy) => this(assignedBy: assignedBy);

  @override
  OfferOut sentAt(DateTime sentAt) => this(sentAt: sentAt);

  @override
  OfferOut timeoutAt(DateTime timeoutAt) => this(timeoutAt: timeoutAt);

  @override
  OfferOut response(String response) => this(response: response);

  @override
  OfferOut respondedAt(DateTime? respondedAt) => this(respondedAt: respondedAt);

  @override
  OfferOut declineReason(String declineReason) =>
      this(declineReason: declineReason);

  @override
  OfferOut declineNote(String declineNote) => this(declineNote: declineNote);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferOut(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? partnerId = const $CopyWithPlaceholder(),
    Object? partnerName = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? alternatePhone = const $CopyWithPlaceholder(),
    Object? assignedBy = const $CopyWithPlaceholder(),
    Object? sentAt = const $CopyWithPlaceholder(),
    Object? timeoutAt = const $CopyWithPlaceholder(),
    Object? response = const $CopyWithPlaceholder(),
    Object? respondedAt = const $CopyWithPlaceholder(),
    Object? declineReason = const $CopyWithPlaceholder(),
    Object? declineNote = const $CopyWithPlaceholder(),
  }) {
    return OfferOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as String,
      partnerId: partnerId == const $CopyWithPlaceholder()
          ? _value.partnerId
          // ignore: cast_nullable_to_non_nullable
          : partnerId as String,
      partnerName: partnerName == const $CopyWithPlaceholder()
          ? _value.partnerName
          // ignore: cast_nullable_to_non_nullable
          : partnerName as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      alternatePhone: alternatePhone == const $CopyWithPlaceholder()
          ? _value.alternatePhone
          // ignore: cast_nullable_to_non_nullable
          : alternatePhone as String,
      assignedBy: assignedBy == const $CopyWithPlaceholder()
          ? _value.assignedBy
          // ignore: cast_nullable_to_non_nullable
          : assignedBy as String,
      sentAt: sentAt == const $CopyWithPlaceholder()
          ? _value.sentAt
          // ignore: cast_nullable_to_non_nullable
          : sentAt as DateTime,
      timeoutAt: timeoutAt == const $CopyWithPlaceholder()
          ? _value.timeoutAt
          // ignore: cast_nullable_to_non_nullable
          : timeoutAt as DateTime,
      response: response == const $CopyWithPlaceholder()
          ? _value.response
          // ignore: cast_nullable_to_non_nullable
          : response as String,
      respondedAt: respondedAt == const $CopyWithPlaceholder()
          ? _value.respondedAt
          // ignore: cast_nullable_to_non_nullable
          : respondedAt as DateTime?,
      declineReason: declineReason == const $CopyWithPlaceholder()
          ? _value.declineReason
          // ignore: cast_nullable_to_non_nullable
          : declineReason as String,
      declineNote: declineNote == const $CopyWithPlaceholder()
          ? _value.declineNote
          // ignore: cast_nullable_to_non_nullable
          : declineNote as String,
    );
  }
}

extension $OfferOutCopyWith on OfferOut {
  /// Returns a callable class that can be used as follows: `instanceOfOfferOut.copyWith(...)` or like so:`instanceOfOfferOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OfferOutCWProxy get copyWith => _$OfferOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferOut _$OfferOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OfferOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'kind',
          'partnerId',
          'partnerName',
          'phone',
          'alternatePhone',
          'assignedBy',
          'sentAt',
          'timeoutAt',
          'response',
          'respondedAt',
          'declineReason',
          'declineNote',
        ],
      );
      final val = OfferOut(
        id: $checkedConvert('id', (v) => v as String),
        kind: $checkedConvert('kind', (v) => v as String),
        partnerId: $checkedConvert('partnerId', (v) => v as String),
        partnerName: $checkedConvert('partnerName', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        alternatePhone: $checkedConvert('alternatePhone', (v) => v as String),
        assignedBy: $checkedConvert('assignedBy', (v) => v as String),
        sentAt: $checkedConvert('sentAt', (v) => DateTime.parse(v as String)),
        timeoutAt: $checkedConvert(
          'timeoutAt',
          (v) => DateTime.parse(v as String),
        ),
        response: $checkedConvert('response', (v) => v as String),
        respondedAt: $checkedConvert(
          'respondedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        declineReason: $checkedConvert('declineReason', (v) => v as String),
        declineNote: $checkedConvert('declineNote', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$OfferOutToJson(OfferOut instance) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'partnerId': instance.partnerId,
  'partnerName': instance.partnerName,
  'phone': instance.phone,
  'alternatePhone': instance.alternatePhone,
  'assignedBy': instance.assignedBy,
  'sentAt': instance.sentAt.toIso8601String(),
  'timeoutAt': instance.timeoutAt.toIso8601String(),
  'response': instance.response,
  'respondedAt': instance.respondedAt?.toIso8601String(),
  'declineReason': instance.declineReason,
  'declineNote': instance.declineNote,
};

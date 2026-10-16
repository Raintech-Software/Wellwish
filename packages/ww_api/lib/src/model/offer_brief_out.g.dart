// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_brief_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OfferBriefOutCWProxy {
  OfferBriefOut assignmentId(String assignmentId);

  OfferBriefOut kind(String kind);

  OfferBriefOut partnerId(String partnerId);

  OfferBriefOut partnerName(String partnerName);

  OfferBriefOut sentAt(DateTime sentAt);

  OfferBriefOut timeoutAt(DateTime timeoutAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferBriefOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferBriefOut(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferBriefOut call({
    String assignmentId,
    String kind,
    String partnerId,
    String partnerName,
    DateTime sentAt,
    DateTime timeoutAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOfferBriefOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOfferBriefOut.copyWith.fieldName(...)`
class _$OfferBriefOutCWProxyImpl implements _$OfferBriefOutCWProxy {
  const _$OfferBriefOutCWProxyImpl(this._value);

  final OfferBriefOut _value;

  @override
  OfferBriefOut assignmentId(String assignmentId) =>
      this(assignmentId: assignmentId);

  @override
  OfferBriefOut kind(String kind) => this(kind: kind);

  @override
  OfferBriefOut partnerId(String partnerId) => this(partnerId: partnerId);

  @override
  OfferBriefOut partnerName(String partnerName) =>
      this(partnerName: partnerName);

  @override
  OfferBriefOut sentAt(DateTime sentAt) => this(sentAt: sentAt);

  @override
  OfferBriefOut timeoutAt(DateTime timeoutAt) => this(timeoutAt: timeoutAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferBriefOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferBriefOut(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferBriefOut call({
    Object? assignmentId = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? partnerId = const $CopyWithPlaceholder(),
    Object? partnerName = const $CopyWithPlaceholder(),
    Object? sentAt = const $CopyWithPlaceholder(),
    Object? timeoutAt = const $CopyWithPlaceholder(),
  }) {
    return OfferBriefOut(
      assignmentId: assignmentId == const $CopyWithPlaceholder()
          ? _value.assignmentId
          // ignore: cast_nullable_to_non_nullable
          : assignmentId as String,
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
      sentAt: sentAt == const $CopyWithPlaceholder()
          ? _value.sentAt
          // ignore: cast_nullable_to_non_nullable
          : sentAt as DateTime,
      timeoutAt: timeoutAt == const $CopyWithPlaceholder()
          ? _value.timeoutAt
          // ignore: cast_nullable_to_non_nullable
          : timeoutAt as DateTime,
    );
  }
}

extension $OfferBriefOutCopyWith on OfferBriefOut {
  /// Returns a callable class that can be used as follows: `instanceOfOfferBriefOut.copyWith(...)` or like so:`instanceOfOfferBriefOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OfferBriefOutCWProxy get copyWith => _$OfferBriefOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferBriefOut _$OfferBriefOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OfferBriefOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'assignmentId',
          'kind',
          'partnerId',
          'partnerName',
          'sentAt',
          'timeoutAt',
        ],
      );
      final val = OfferBriefOut(
        assignmentId: $checkedConvert('assignmentId', (v) => v as String),
        kind: $checkedConvert('kind', (v) => v as String),
        partnerId: $checkedConvert('partnerId', (v) => v as String),
        partnerName: $checkedConvert('partnerName', (v) => v as String),
        sentAt: $checkedConvert('sentAt', (v) => DateTime.parse(v as String)),
        timeoutAt: $checkedConvert(
          'timeoutAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$OfferBriefOutToJson(OfferBriefOut instance) =>
    <String, dynamic>{
      'assignmentId': instance.assignmentId,
      'kind': instance.kind,
      'partnerId': instance.partnerId,
      'partnerName': instance.partnerName,
      'sentAt': instance.sentAt.toIso8601String(),
      'timeoutAt': instance.timeoutAt.toIso8601String(),
    };

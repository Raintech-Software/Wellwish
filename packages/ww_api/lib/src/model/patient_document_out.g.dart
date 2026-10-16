// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_document_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientDocumentOutCWProxy {
  PatientDocumentOut id(String id);

  PatientDocumentOut memberId(String memberId);

  PatientDocumentOut memberName(String memberName);

  PatientDocumentOut type(String type);

  PatientDocumentOut title(String title);

  PatientDocumentOut date(DateTime? date);

  PatientDocumentOut mime(String mime);

  PatientDocumentOut sizeBytes(int sizeBytes);

  PatientDocumentOut createdAt(DateTime createdAt);

  PatientDocumentOut text(String? text);

  PatientDocumentOut vitals(Map<String, Object>? vitals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDocumentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDocumentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDocumentOut call({
    String id,
    String memberId,
    String memberName,
    String type,
    String title,
    DateTime? date,
    String mime,
    int sizeBytes,
    DateTime createdAt,
    String? text,
    Map<String, Object>? vitals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientDocumentOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientDocumentOut.copyWith.fieldName(...)`
class _$PatientDocumentOutCWProxyImpl implements _$PatientDocumentOutCWProxy {
  const _$PatientDocumentOutCWProxyImpl(this._value);

  final PatientDocumentOut _value;

  @override
  PatientDocumentOut id(String id) => this(id: id);

  @override
  PatientDocumentOut memberId(String memberId) => this(memberId: memberId);

  @override
  PatientDocumentOut memberName(String memberName) =>
      this(memberName: memberName);

  @override
  PatientDocumentOut type(String type) => this(type: type);

  @override
  PatientDocumentOut title(String title) => this(title: title);

  @override
  PatientDocumentOut date(DateTime? date) => this(date: date);

  @override
  PatientDocumentOut mime(String mime) => this(mime: mime);

  @override
  PatientDocumentOut sizeBytes(int sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  PatientDocumentOut createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  PatientDocumentOut text(String? text) => this(text: text);

  @override
  PatientDocumentOut vitals(Map<String, Object>? vitals) =>
      this(vitals: vitals);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDocumentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDocumentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDocumentOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? memberId = const $CopyWithPlaceholder(),
    Object? memberName = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? vitals = const $CopyWithPlaceholder(),
  }) {
    return PatientDocumentOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      memberId: memberId == const $CopyWithPlaceholder()
          ? _value.memberId
          // ignore: cast_nullable_to_non_nullable
          : memberId as String,
      memberName: memberName == const $CopyWithPlaceholder()
          ? _value.memberName
          // ignore: cast_nullable_to_non_nullable
          : memberName as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime?,
      mime: mime == const $CopyWithPlaceholder()
          ? _value.mime
          // ignore: cast_nullable_to_non_nullable
          : mime as String,
      sizeBytes: sizeBytes == const $CopyWithPlaceholder()
          ? _value.sizeBytes
          // ignore: cast_nullable_to_non_nullable
          : sizeBytes as int,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String?,
      vitals: vitals == const $CopyWithPlaceholder()
          ? _value.vitals
          // ignore: cast_nullable_to_non_nullable
          : vitals as Map<String, Object>?,
    );
  }
}

extension $PatientDocumentOutCopyWith on PatientDocumentOut {
  /// Returns a callable class that can be used as follows: `instanceOfPatientDocumentOut.copyWith(...)` or like so:`instanceOfPatientDocumentOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientDocumentOutCWProxy get copyWith =>
      _$PatientDocumentOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientDocumentOut _$PatientDocumentOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PatientDocumentOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'memberId',
      'memberName',
      'type',
      'title',
      'date',
      'mime',
      'sizeBytes',
      'createdAt',
    ],
  );
  final val = PatientDocumentOut(
    id: $checkedConvert('id', (v) => v as String),
    memberId: $checkedConvert('memberId', (v) => v as String),
    memberName: $checkedConvert('memberName', (v) => v as String),
    type: $checkedConvert('type', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    date: $checkedConvert(
      'date',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    mime: $checkedConvert('mime', (v) => v as String),
    sizeBytes: $checkedConvert('sizeBytes', (v) => (v as num).toInt()),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    text: $checkedConvert('text', (v) => v as String? ?? ''),
    vitals: $checkedConvert(
      'vitals',
      (v) =>
          (v as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as Object)),
    ),
  );
  return val;
});

Map<String, dynamic> _$PatientDocumentOutToJson(PatientDocumentOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'type': instance.type,
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
      'mime': instance.mime,
      'sizeBytes': instance.sizeBytes,
      'createdAt': instance.createdAt.toIso8601String(),
      'text': ?instance.text,
      'vitals': ?instance.vitals,
    };

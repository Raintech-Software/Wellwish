// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_detail_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientDetailOutCWProxy {
  PatientDetailOut patient(PatientRowOut patient);

  PatientDetailOut dob(DateTime? dob);

  PatientDetailOut gender(String gender);

  PatientDetailOut language(String language);

  PatientDetailOut members(List<AdminMemberOut> members);

  PatientDetailOut addresses(List<AddressOut> addresses);

  PatientDetailOut documentsVisible(bool documentsVisible);

  PatientDetailOut documents(List<PatientDocumentOut> documents);

  PatientDetailOut bookingsVisible(bool bookingsVisible);

  PatientDetailOut bookings(List<AdminBookingRowOut> bookings);

  PatientDetailOut blockedReason(String? blockedReason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDetailOut call({
    PatientRowOut patient,
    DateTime? dob,
    String gender,
    String language,
    List<AdminMemberOut> members,
    List<AddressOut> addresses,
    bool documentsVisible,
    List<PatientDocumentOut> documents,
    bool bookingsVisible,
    List<AdminBookingRowOut> bookings,
    String? blockedReason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientDetailOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientDetailOut.copyWith.fieldName(...)`
class _$PatientDetailOutCWProxyImpl implements _$PatientDetailOutCWProxy {
  const _$PatientDetailOutCWProxyImpl(this._value);

  final PatientDetailOut _value;

  @override
  PatientDetailOut patient(PatientRowOut patient) => this(patient: patient);

  @override
  PatientDetailOut dob(DateTime? dob) => this(dob: dob);

  @override
  PatientDetailOut gender(String gender) => this(gender: gender);

  @override
  PatientDetailOut language(String language) => this(language: language);

  @override
  PatientDetailOut members(List<AdminMemberOut> members) =>
      this(members: members);

  @override
  PatientDetailOut addresses(List<AddressOut> addresses) =>
      this(addresses: addresses);

  @override
  PatientDetailOut documentsVisible(bool documentsVisible) =>
      this(documentsVisible: documentsVisible);

  @override
  PatientDetailOut documents(List<PatientDocumentOut> documents) =>
      this(documents: documents);

  @override
  PatientDetailOut bookingsVisible(bool bookingsVisible) =>
      this(bookingsVisible: bookingsVisible);

  @override
  PatientDetailOut bookings(List<AdminBookingRowOut> bookings) =>
      this(bookings: bookings);

  @override
  PatientDetailOut blockedReason(String? blockedReason) =>
      this(blockedReason: blockedReason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDetailOut call({
    Object? patient = const $CopyWithPlaceholder(),
    Object? dob = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? members = const $CopyWithPlaceholder(),
    Object? addresses = const $CopyWithPlaceholder(),
    Object? documentsVisible = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? bookingsVisible = const $CopyWithPlaceholder(),
    Object? bookings = const $CopyWithPlaceholder(),
    Object? blockedReason = const $CopyWithPlaceholder(),
  }) {
    return PatientDetailOut(
      patient: patient == const $CopyWithPlaceholder()
          ? _value.patient
          // ignore: cast_nullable_to_non_nullable
          : patient as PatientRowOut,
      dob: dob == const $CopyWithPlaceholder()
          ? _value.dob
          // ignore: cast_nullable_to_non_nullable
          : dob as DateTime?,
      gender: gender == const $CopyWithPlaceholder()
          ? _value.gender
          // ignore: cast_nullable_to_non_nullable
          : gender as String,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String,
      members: members == const $CopyWithPlaceholder()
          ? _value.members
          // ignore: cast_nullable_to_non_nullable
          : members as List<AdminMemberOut>,
      addresses: addresses == const $CopyWithPlaceholder()
          ? _value.addresses
          // ignore: cast_nullable_to_non_nullable
          : addresses as List<AddressOut>,
      documentsVisible: documentsVisible == const $CopyWithPlaceholder()
          ? _value.documentsVisible
          // ignore: cast_nullable_to_non_nullable
          : documentsVisible as bool,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<PatientDocumentOut>,
      bookingsVisible: bookingsVisible == const $CopyWithPlaceholder()
          ? _value.bookingsVisible
          // ignore: cast_nullable_to_non_nullable
          : bookingsVisible as bool,
      bookings: bookings == const $CopyWithPlaceholder()
          ? _value.bookings
          // ignore: cast_nullable_to_non_nullable
          : bookings as List<AdminBookingRowOut>,
      blockedReason: blockedReason == const $CopyWithPlaceholder()
          ? _value.blockedReason
          // ignore: cast_nullable_to_non_nullable
          : blockedReason as String?,
    );
  }
}

extension $PatientDetailOutCopyWith on PatientDetailOut {
  /// Returns a callable class that can be used as follows: `instanceOfPatientDetailOut.copyWith(...)` or like so:`instanceOfPatientDetailOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientDetailOutCWProxy get copyWith => _$PatientDetailOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientDetailOut _$PatientDetailOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PatientDetailOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'patient',
      'dob',
      'gender',
      'language',
      'members',
      'addresses',
      'documentsVisible',
      'documents',
      'bookingsVisible',
      'bookings',
    ],
  );
  final val = PatientDetailOut(
    patient: $checkedConvert(
      'patient',
      (v) => PatientRowOut.fromJson(v as Map<String, dynamic>),
    ),
    dob: $checkedConvert(
      'dob',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    gender: $checkedConvert('gender', (v) => v as String),
    language: $checkedConvert('language', (v) => v as String),
    members: $checkedConvert(
      'members',
      (v) => (v as List<dynamic>)
          .map((e) => AdminMemberOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    addresses: $checkedConvert(
      'addresses',
      (v) => (v as List<dynamic>)
          .map((e) => AddressOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    documentsVisible: $checkedConvert('documentsVisible', (v) => v as bool),
    documents: $checkedConvert(
      'documents',
      (v) => (v as List<dynamic>)
          .map((e) => PatientDocumentOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    bookingsVisible: $checkedConvert('bookingsVisible', (v) => v as bool),
    bookings: $checkedConvert(
      'bookings',
      (v) => (v as List<dynamic>)
          .map((e) => AdminBookingRowOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    blockedReason: $checkedConvert('blockedReason', (v) => v as String? ?? ''),
  );
  return val;
});

Map<String, dynamic> _$PatientDetailOutToJson(PatientDetailOut instance) =>
    <String, dynamic>{
      'patient': instance.patient.toJson(),
      'dob': instance.dob?.toIso8601String(),
      'gender': instance.gender,
      'language': instance.language,
      'members': instance.members.map((e) => e.toJson()).toList(),
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'documentsVisible': instance.documentsVisible,
      'documents': instance.documents.map((e) => e.toJson()).toList(),
      'bookingsVisible': instance.bookingsVisible,
      'bookings': instance.bookings.map((e) => e.toJson()).toList(),
      'blockedReason': ?instance.blockedReason,
    };

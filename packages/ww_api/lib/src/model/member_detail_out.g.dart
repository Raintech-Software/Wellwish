// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_detail_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MemberDetailOutCWProxy {
  MemberDetailOut member(MemberOut member);

  MemberDetailOut addresses(List<AddressOut> addresses);

  MemberDetailOut documents(List<PatientDocumentOut> documents);

  MemberDetailOut bookings(List<BookingRowOut> bookings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MemberDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MemberDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  MemberDetailOut call({
    MemberOut member,
    List<AddressOut> addresses,
    List<PatientDocumentOut> documents,
    List<BookingRowOut> bookings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMemberDetailOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMemberDetailOut.copyWith.fieldName(...)`
class _$MemberDetailOutCWProxyImpl implements _$MemberDetailOutCWProxy {
  const _$MemberDetailOutCWProxyImpl(this._value);

  final MemberDetailOut _value;

  @override
  MemberDetailOut member(MemberOut member) => this(member: member);

  @override
  MemberDetailOut addresses(List<AddressOut> addresses) =>
      this(addresses: addresses);

  @override
  MemberDetailOut documents(List<PatientDocumentOut> documents) =>
      this(documents: documents);

  @override
  MemberDetailOut bookings(List<BookingRowOut> bookings) =>
      this(bookings: bookings);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MemberDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MemberDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  MemberDetailOut call({
    Object? member = const $CopyWithPlaceholder(),
    Object? addresses = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? bookings = const $CopyWithPlaceholder(),
  }) {
    return MemberDetailOut(
      member: member == const $CopyWithPlaceholder()
          ? _value.member
          // ignore: cast_nullable_to_non_nullable
          : member as MemberOut,
      addresses: addresses == const $CopyWithPlaceholder()
          ? _value.addresses
          // ignore: cast_nullable_to_non_nullable
          : addresses as List<AddressOut>,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<PatientDocumentOut>,
      bookings: bookings == const $CopyWithPlaceholder()
          ? _value.bookings
          // ignore: cast_nullable_to_non_nullable
          : bookings as List<BookingRowOut>,
    );
  }
}

extension $MemberDetailOutCopyWith on MemberDetailOut {
  /// Returns a callable class that can be used as follows: `instanceOfMemberDetailOut.copyWith(...)` or like so:`instanceOfMemberDetailOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MemberDetailOutCWProxy get copyWith => _$MemberDetailOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberDetailOut _$MemberDetailOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MemberDetailOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['member', 'addresses', 'documents', 'bookings'],
      );
      final val = MemberDetailOut(
        member: $checkedConvert(
          'member',
          (v) => MemberOut.fromJson(v as Map<String, dynamic>),
        ),
        addresses: $checkedConvert(
          'addresses',
          (v) => (v as List<dynamic>)
              .map((e) => AddressOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        documents: $checkedConvert(
          'documents',
          (v) => (v as List<dynamic>)
              .map(
                (e) => PatientDocumentOut.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        bookings: $checkedConvert(
          'bookings',
          (v) => (v as List<dynamic>)
              .map((e) => BookingRowOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MemberDetailOutToJson(MemberDetailOut instance) =>
    <String, dynamic>{
      'member': instance.member.toJson(),
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'documents': instance.documents.map((e) => e.toJson()).toList(),
      'bookings': instance.bookings.map((e) => e.toJson()).toList(),
    };

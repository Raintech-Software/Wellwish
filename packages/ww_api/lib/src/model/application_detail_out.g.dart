// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_detail_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApplicationDetailOutCWProxy {
  ApplicationDetailOut application(ApplicationOut application);

  ApplicationDetailOut partner(PartnerProfileOut partner);

  ApplicationDetailOut documents(List<DocStateOut> documents);

  ApplicationDetailOut claimedByMe(bool claimedByMe);

  ApplicationDetailOut canApprove(bool canApprove);

  ApplicationDetailOut missingDocuments(List<String> missingDocuments);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationDetailOut call({
    ApplicationOut application,
    PartnerProfileOut partner,
    List<DocStateOut> documents,
    bool claimedByMe,
    bool canApprove,
    List<String> missingDocuments,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApplicationDetailOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApplicationDetailOut.copyWith.fieldName(...)`
class _$ApplicationDetailOutCWProxyImpl
    implements _$ApplicationDetailOutCWProxy {
  const _$ApplicationDetailOutCWProxyImpl(this._value);

  final ApplicationDetailOut _value;

  @override
  ApplicationDetailOut application(ApplicationOut application) =>
      this(application: application);

  @override
  ApplicationDetailOut partner(PartnerProfileOut partner) =>
      this(partner: partner);

  @override
  ApplicationDetailOut documents(List<DocStateOut> documents) =>
      this(documents: documents);

  @override
  ApplicationDetailOut claimedByMe(bool claimedByMe) =>
      this(claimedByMe: claimedByMe);

  @override
  ApplicationDetailOut canApprove(bool canApprove) =>
      this(canApprove: canApprove);

  @override
  ApplicationDetailOut missingDocuments(List<String> missingDocuments) =>
      this(missingDocuments: missingDocuments);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationDetailOut call({
    Object? application = const $CopyWithPlaceholder(),
    Object? partner = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? claimedByMe = const $CopyWithPlaceholder(),
    Object? canApprove = const $CopyWithPlaceholder(),
    Object? missingDocuments = const $CopyWithPlaceholder(),
  }) {
    return ApplicationDetailOut(
      application: application == const $CopyWithPlaceholder()
          ? _value.application
          // ignore: cast_nullable_to_non_nullable
          : application as ApplicationOut,
      partner: partner == const $CopyWithPlaceholder()
          ? _value.partner
          // ignore: cast_nullable_to_non_nullable
          : partner as PartnerProfileOut,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<DocStateOut>,
      claimedByMe: claimedByMe == const $CopyWithPlaceholder()
          ? _value.claimedByMe
          // ignore: cast_nullable_to_non_nullable
          : claimedByMe as bool,
      canApprove: canApprove == const $CopyWithPlaceholder()
          ? _value.canApprove
          // ignore: cast_nullable_to_non_nullable
          : canApprove as bool,
      missingDocuments: missingDocuments == const $CopyWithPlaceholder()
          ? _value.missingDocuments
          // ignore: cast_nullable_to_non_nullable
          : missingDocuments as List<String>,
    );
  }
}

extension $ApplicationDetailOutCopyWith on ApplicationDetailOut {
  /// Returns a callable class that can be used as follows: `instanceOfApplicationDetailOut.copyWith(...)` or like so:`instanceOfApplicationDetailOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApplicationDetailOutCWProxy get copyWith =>
      _$ApplicationDetailOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationDetailOut _$ApplicationDetailOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApplicationDetailOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'application',
      'partner',
      'documents',
      'claimedByMe',
      'canApprove',
      'missingDocuments',
    ],
  );
  final val = ApplicationDetailOut(
    application: $checkedConvert(
      'application',
      (v) => ApplicationOut.fromJson(v as Map<String, dynamic>),
    ),
    partner: $checkedConvert(
      'partner',
      (v) => PartnerProfileOut.fromJson(v as Map<String, dynamic>),
    ),
    documents: $checkedConvert(
      'documents',
      (v) => (v as List<dynamic>)
          .map((e) => DocStateOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    claimedByMe: $checkedConvert('claimedByMe', (v) => v as bool),
    canApprove: $checkedConvert('canApprove', (v) => v as bool),
    missingDocuments: $checkedConvert(
      'missingDocuments',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ApplicationDetailOutToJson(
  ApplicationDetailOut instance,
) => <String, dynamic>{
  'application': instance.application.toJson(),
  'partner': instance.partner.toJson(),
  'documents': instance.documents.map((e) => e.toJson()).toList(),
  'claimedByMe': instance.claimedByMe,
  'canApprove': instance.canApprove,
  'missingDocuments': instance.missingDocuments,
};

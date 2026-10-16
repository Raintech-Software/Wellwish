// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_status_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$KycStatusOutCWProxy {
  KycStatusOut profile(PartnerProfileOut profile);

  KycStatusOut steps(StepsOut steps);

  KycStatusOut canEdit(bool canEdit);

  KycStatusOut canSubmit(bool canSubmit);

  KycStatusOut documents(List<DocStateOut> documents);

  KycStatusOut application(ApplicationOut? application);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KycStatusOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KycStatusOut(...).copyWith(id: 12, name: "My name")
  /// ````
  KycStatusOut call({
    PartnerProfileOut profile,
    StepsOut steps,
    bool canEdit,
    bool canSubmit,
    List<DocStateOut> documents,
    ApplicationOut? application,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfKycStatusOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfKycStatusOut.copyWith.fieldName(...)`
class _$KycStatusOutCWProxyImpl implements _$KycStatusOutCWProxy {
  const _$KycStatusOutCWProxyImpl(this._value);

  final KycStatusOut _value;

  @override
  KycStatusOut profile(PartnerProfileOut profile) => this(profile: profile);

  @override
  KycStatusOut steps(StepsOut steps) => this(steps: steps);

  @override
  KycStatusOut canEdit(bool canEdit) => this(canEdit: canEdit);

  @override
  KycStatusOut canSubmit(bool canSubmit) => this(canSubmit: canSubmit);

  @override
  KycStatusOut documents(List<DocStateOut> documents) =>
      this(documents: documents);

  @override
  KycStatusOut application(ApplicationOut? application) =>
      this(application: application);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KycStatusOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KycStatusOut(...).copyWith(id: 12, name: "My name")
  /// ````
  KycStatusOut call({
    Object? profile = const $CopyWithPlaceholder(),
    Object? steps = const $CopyWithPlaceholder(),
    Object? canEdit = const $CopyWithPlaceholder(),
    Object? canSubmit = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? application = const $CopyWithPlaceholder(),
  }) {
    return KycStatusOut(
      profile: profile == const $CopyWithPlaceholder()
          ? _value.profile
          // ignore: cast_nullable_to_non_nullable
          : profile as PartnerProfileOut,
      steps: steps == const $CopyWithPlaceholder()
          ? _value.steps
          // ignore: cast_nullable_to_non_nullable
          : steps as StepsOut,
      canEdit: canEdit == const $CopyWithPlaceholder()
          ? _value.canEdit
          // ignore: cast_nullable_to_non_nullable
          : canEdit as bool,
      canSubmit: canSubmit == const $CopyWithPlaceholder()
          ? _value.canSubmit
          // ignore: cast_nullable_to_non_nullable
          : canSubmit as bool,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<DocStateOut>,
      application: application == const $CopyWithPlaceholder()
          ? _value.application
          // ignore: cast_nullable_to_non_nullable
          : application as ApplicationOut?,
    );
  }
}

extension $KycStatusOutCopyWith on KycStatusOut {
  /// Returns a callable class that can be used as follows: `instanceOfKycStatusOut.copyWith(...)` or like so:`instanceOfKycStatusOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$KycStatusOutCWProxy get copyWith => _$KycStatusOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KycStatusOut _$KycStatusOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('KycStatusOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'profile',
          'steps',
          'canEdit',
          'canSubmit',
          'documents',
          'application',
        ],
      );
      final val = KycStatusOut(
        profile: $checkedConvert(
          'profile',
          (v) => PartnerProfileOut.fromJson(v as Map<String, dynamic>),
        ),
        steps: $checkedConvert(
          'steps',
          (v) => StepsOut.fromJson(v as Map<String, dynamic>),
        ),
        canEdit: $checkedConvert('canEdit', (v) => v as bool),
        canSubmit: $checkedConvert('canSubmit', (v) => v as bool),
        documents: $checkedConvert(
          'documents',
          (v) => (v as List<dynamic>)
              .map((e) => DocStateOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        application: $checkedConvert(
          'application',
          (v) => v == null
              ? null
              : ApplicationOut.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$KycStatusOutToJson(KycStatusOut instance) =>
    <String, dynamic>{
      'profile': instance.profile.toJson(),
      'steps': instance.steps.toJson(),
      'canEdit': instance.canEdit,
      'canSubmit': instance.canSubmit,
      'documents': instance.documents.map((e) => e.toJson()).toList(),
      'application': instance.application?.toJson(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StepsOutCWProxy {
  StepsOut role(bool role);

  StepsOut alternatePhone(bool alternatePhone);

  StepsOut email(bool email);

  StepsOut profile(bool profile);

  StepsOut documents(bool documents);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StepsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StepsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StepsOut call({
    bool role,
    bool alternatePhone,
    bool email,
    bool profile,
    bool documents,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStepsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStepsOut.copyWith.fieldName(...)`
class _$StepsOutCWProxyImpl implements _$StepsOutCWProxy {
  const _$StepsOutCWProxyImpl(this._value);

  final StepsOut _value;

  @override
  StepsOut role(bool role) => this(role: role);

  @override
  StepsOut alternatePhone(bool alternatePhone) =>
      this(alternatePhone: alternatePhone);

  @override
  StepsOut email(bool email) => this(email: email);

  @override
  StepsOut profile(bool profile) => this(profile: profile);

  @override
  StepsOut documents(bool documents) => this(documents: documents);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StepsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StepsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StepsOut call({
    Object? role = const $CopyWithPlaceholder(),
    Object? alternatePhone = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? profile = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
  }) {
    return StepsOut(
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as bool,
      alternatePhone: alternatePhone == const $CopyWithPlaceholder()
          ? _value.alternatePhone
          // ignore: cast_nullable_to_non_nullable
          : alternatePhone as bool,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as bool,
      profile: profile == const $CopyWithPlaceholder()
          ? _value.profile
          // ignore: cast_nullable_to_non_nullable
          : profile as bool,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as bool,
    );
  }
}

extension $StepsOutCopyWith on StepsOut {
  /// Returns a callable class that can be used as follows: `instanceOfStepsOut.copyWith(...)` or like so:`instanceOfStepsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StepsOutCWProxy get copyWith => _$StepsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepsOut _$StepsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StepsOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'role',
          'alternatePhone',
          'email',
          'profile',
          'documents',
        ],
      );
      final val = StepsOut(
        role: $checkedConvert('role', (v) => v as bool),
        alternatePhone: $checkedConvert('alternatePhone', (v) => v as bool),
        email: $checkedConvert('email', (v) => v as bool),
        profile: $checkedConvert('profile', (v) => v as bool),
        documents: $checkedConvert('documents', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$StepsOutToJson(StepsOut instance) => <String, dynamic>{
  'role': instance.role,
  'alternatePhone': instance.alternatePhone,
  'email': instance.email,
  'profile': instance.profile,
  'documents': instance.documents,
};

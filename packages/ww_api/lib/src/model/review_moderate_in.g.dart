// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_moderate_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReviewModerateInCWProxy {
  ReviewModerateIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReviewModerateIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReviewModerateIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReviewModerateIn call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReviewModerateIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReviewModerateIn.copyWith.fieldName(...)`
class _$ReviewModerateInCWProxyImpl implements _$ReviewModerateInCWProxy {
  const _$ReviewModerateInCWProxyImpl(this._value);

  final ReviewModerateIn _value;

  @override
  ReviewModerateIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReviewModerateIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReviewModerateIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReviewModerateIn call({Object? reason = const $CopyWithPlaceholder()}) {
    return ReviewModerateIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $ReviewModerateInCopyWith on ReviewModerateIn {
  /// Returns a callable class that can be used as follows: `instanceOfReviewModerateIn.copyWith(...)` or like so:`instanceOfReviewModerateIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReviewModerateInCWProxy get copyWith => _$ReviewModerateInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModerateIn _$ReviewModerateInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReviewModerateIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = ReviewModerateIn(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ReviewModerateInToJson(ReviewModerateIn instance) =>
    <String, dynamic>{'reason': instance.reason};

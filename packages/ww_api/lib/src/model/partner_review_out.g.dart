// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_review_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerReviewOutCWProxy {
  PartnerReviewOut stars(int stars);

  PartnerReviewOut tags(List<String> tags);

  PartnerReviewOut comment(String comment);

  PartnerReviewOut createdAt(DateTime createdAt);

  PartnerReviewOut serviceName(String serviceName);

  PartnerReviewOut serviceNameHi(String? serviceNameHi);

  PartnerReviewOut serviceNameOr(String? serviceNameOr);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerReviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerReviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerReviewOut call({
    int stars,
    List<String> tags,
    String comment,
    DateTime createdAt,
    String serviceName,
    String? serviceNameHi,
    String? serviceNameOr,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerReviewOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerReviewOut.copyWith.fieldName(...)`
class _$PartnerReviewOutCWProxyImpl implements _$PartnerReviewOutCWProxy {
  const _$PartnerReviewOutCWProxyImpl(this._value);

  final PartnerReviewOut _value;

  @override
  PartnerReviewOut stars(int stars) => this(stars: stars);

  @override
  PartnerReviewOut tags(List<String> tags) => this(tags: tags);

  @override
  PartnerReviewOut comment(String comment) => this(comment: comment);

  @override
  PartnerReviewOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  PartnerReviewOut serviceName(String serviceName) =>
      this(serviceName: serviceName);

  @override
  PartnerReviewOut serviceNameHi(String? serviceNameHi) =>
      this(serviceNameHi: serviceNameHi);

  @override
  PartnerReviewOut serviceNameOr(String? serviceNameOr) =>
      this(serviceNameOr: serviceNameOr);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerReviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerReviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerReviewOut call({
    Object? stars = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? serviceName = const $CopyWithPlaceholder(),
    Object? serviceNameHi = const $CopyWithPlaceholder(),
    Object? serviceNameOr = const $CopyWithPlaceholder(),
  }) {
    return PartnerReviewOut(
      stars: stars == const $CopyWithPlaceholder()
          ? _value.stars
          // ignore: cast_nullable_to_non_nullable
          : stars as int,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<String>,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      serviceName: serviceName == const $CopyWithPlaceholder()
          ? _value.serviceName
          // ignore: cast_nullable_to_non_nullable
          : serviceName as String,
      serviceNameHi: serviceNameHi == const $CopyWithPlaceholder()
          ? _value.serviceNameHi
          // ignore: cast_nullable_to_non_nullable
          : serviceNameHi as String?,
      serviceNameOr: serviceNameOr == const $CopyWithPlaceholder()
          ? _value.serviceNameOr
          // ignore: cast_nullable_to_non_nullable
          : serviceNameOr as String?,
    );
  }
}

extension $PartnerReviewOutCopyWith on PartnerReviewOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerReviewOut.copyWith(...)` or like so:`instanceOfPartnerReviewOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerReviewOutCWProxy get copyWith => _$PartnerReviewOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerReviewOut _$PartnerReviewOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PartnerReviewOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'stars',
      'tags',
      'comment',
      'createdAt',
      'serviceName',
    ],
  );
  final val = PartnerReviewOut(
    stars: $checkedConvert('stars', (v) => (v as num).toInt()),
    tags: $checkedConvert(
      'tags',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    comment: $checkedConvert('comment', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    serviceName: $checkedConvert('serviceName', (v) => v as String),
    serviceNameHi: $checkedConvert('serviceNameHi', (v) => v as String? ?? ''),
    serviceNameOr: $checkedConvert('serviceNameOr', (v) => v as String? ?? ''),
  );
  return val;
});

Map<String, dynamic> _$PartnerReviewOutToJson(PartnerReviewOut instance) =>
    <String, dynamic>{
      'stars': instance.stars,
      'tags': instance.tags,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'serviceName': instance.serviceName,
      'serviceNameHi': ?instance.serviceNameHi,
      'serviceNameOr': ?instance.serviceNameOr,
    };

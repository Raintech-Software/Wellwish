// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReviewOutCWProxy {
  ReviewOut stars(int stars);

  ReviewOut tags(List<String> tags);

  ReviewOut comment(String comment);

  ReviewOut createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ReviewOut call({
    int stars,
    List<String> tags,
    String comment,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReviewOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReviewOut.copyWith.fieldName(...)`
class _$ReviewOutCWProxyImpl implements _$ReviewOutCWProxy {
  const _$ReviewOutCWProxyImpl(this._value);

  final ReviewOut _value;

  @override
  ReviewOut stars(int stars) => this(stars: stars);

  @override
  ReviewOut tags(List<String> tags) => this(tags: tags);

  @override
  ReviewOut comment(String comment) => this(comment: comment);

  @override
  ReviewOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ReviewOut call({
    Object? stars = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return ReviewOut(
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
    );
  }
}

extension $ReviewOutCopyWith on ReviewOut {
  /// Returns a callable class that can be used as follows: `instanceOfReviewOut.copyWith(...)` or like so:`instanceOfReviewOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReviewOutCWProxy get copyWith => _$ReviewOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewOut _$ReviewOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReviewOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['stars', 'tags', 'comment', 'createdAt'],
      );
      final val = ReviewOut(
        stars: $checkedConvert('stars', (v) => (v as num).toInt()),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        comment: $checkedConvert('comment', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReviewOutToJson(ReviewOut instance) => <String, dynamic>{
  'stars': instance.stars,
  'tags': instance.tags,
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
};

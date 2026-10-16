// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReviewInCWProxy {
  ReviewIn stars(int stars);

  ReviewIn tags(List<ReviewInTagsEnum>? tags);

  ReviewIn comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReviewIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReviewIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReviewIn call({int stars, List<ReviewInTagsEnum>? tags, String? comment});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReviewIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReviewIn.copyWith.fieldName(...)`
class _$ReviewInCWProxyImpl implements _$ReviewInCWProxy {
  const _$ReviewInCWProxyImpl(this._value);

  final ReviewIn _value;

  @override
  ReviewIn stars(int stars) => this(stars: stars);

  @override
  ReviewIn tags(List<ReviewInTagsEnum>? tags) => this(tags: tags);

  @override
  ReviewIn comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReviewIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReviewIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReviewIn call({
    Object? stars = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return ReviewIn(
      stars: stars == const $CopyWithPlaceholder()
          ? _value.stars
          // ignore: cast_nullable_to_non_nullable
          : stars as int,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<ReviewInTagsEnum>?,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $ReviewInCopyWith on ReviewIn {
  /// Returns a callable class that can be used as follows: `instanceOfReviewIn.copyWith(...)` or like so:`instanceOfReviewIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReviewInCWProxy get copyWith => _$ReviewInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewIn _$ReviewInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReviewIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['stars']);
      final val = ReviewIn(
        stars: $checkedConvert('stars', (v) => (v as num).toInt()),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ReviewInTagsEnumEnumMap, e))
              .toList(),
        ),
        comment: $checkedConvert('comment', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$ReviewInToJson(ReviewIn instance) => <String, dynamic>{
  'stars': instance.stars,
  'tags': ?instance.tags?.map((e) => _$ReviewInTagsEnumEnumMap[e]!).toList(),
  'comment': ?instance.comment,
};

const _$ReviewInTagsEnumEnumMap = {
  ReviewInTagsEnum.ON_TIME: 'ON_TIME',
  ReviewInTagsEnum.KIND: 'KIND',
  ReviewInTagsEnum.HELPFUL: 'HELPFUL',
  ReviewInTagsEnum.PROFESSIONAL: 'PROFESSIONAL',
  ReviewInTagsEnum.GOOD_COMMUNICATION: 'GOOD_COMMUNICATION',
  ReviewInTagsEnum.LATE: 'LATE',
  ReviewInTagsEnum.RUDE: 'RUDE',
  ReviewInTagsEnum.UNHELPFUL: 'UNHELPFUL',
};

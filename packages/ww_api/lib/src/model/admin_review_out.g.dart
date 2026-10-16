// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_review_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminReviewOutCWProxy {
  AdminReviewOut stars(int stars);

  AdminReviewOut tags(List<String> tags);

  AdminReviewOut comment(String comment);

  AdminReviewOut createdAt(DateTime createdAt);

  AdminReviewOut id(String id);

  AdminReviewOut bookingId(String bookingId);

  AdminReviewOut code(String code);

  AdminReviewOut partnerId(String partnerId);

  AdminReviewOut partnerName(String partnerName);

  AdminReviewOut status(String status);

  AdminReviewOut hiddenReason(String hiddenReason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminReviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminReviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminReviewOut call({
    int stars,
    List<String> tags,
    String comment,
    DateTime createdAt,
    String id,
    String bookingId,
    String code,
    String partnerId,
    String partnerName,
    String status,
    String hiddenReason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminReviewOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminReviewOut.copyWith.fieldName(...)`
class _$AdminReviewOutCWProxyImpl implements _$AdminReviewOutCWProxy {
  const _$AdminReviewOutCWProxyImpl(this._value);

  final AdminReviewOut _value;

  @override
  AdminReviewOut stars(int stars) => this(stars: stars);

  @override
  AdminReviewOut tags(List<String> tags) => this(tags: tags);

  @override
  AdminReviewOut comment(String comment) => this(comment: comment);

  @override
  AdminReviewOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AdminReviewOut id(String id) => this(id: id);

  @override
  AdminReviewOut bookingId(String bookingId) => this(bookingId: bookingId);

  @override
  AdminReviewOut code(String code) => this(code: code);

  @override
  AdminReviewOut partnerId(String partnerId) => this(partnerId: partnerId);

  @override
  AdminReviewOut partnerName(String partnerName) =>
      this(partnerName: partnerName);

  @override
  AdminReviewOut status(String status) => this(status: status);

  @override
  AdminReviewOut hiddenReason(String hiddenReason) =>
      this(hiddenReason: hiddenReason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminReviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminReviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminReviewOut call({
    Object? stars = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? partnerId = const $CopyWithPlaceholder(),
    Object? partnerName = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? hiddenReason = const $CopyWithPlaceholder(),
  }) {
    return AdminReviewOut(
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
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      partnerId: partnerId == const $CopyWithPlaceholder()
          ? _value.partnerId
          // ignore: cast_nullable_to_non_nullable
          : partnerId as String,
      partnerName: partnerName == const $CopyWithPlaceholder()
          ? _value.partnerName
          // ignore: cast_nullable_to_non_nullable
          : partnerName as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      hiddenReason: hiddenReason == const $CopyWithPlaceholder()
          ? _value.hiddenReason
          // ignore: cast_nullable_to_non_nullable
          : hiddenReason as String,
    );
  }
}

extension $AdminReviewOutCopyWith on AdminReviewOut {
  /// Returns a callable class that can be used as follows: `instanceOfAdminReviewOut.copyWith(...)` or like so:`instanceOfAdminReviewOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminReviewOutCWProxy get copyWith => _$AdminReviewOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminReviewOut _$AdminReviewOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminReviewOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'stars',
          'tags',
          'comment',
          'createdAt',
          'id',
          'bookingId',
          'code',
          'partnerId',
          'partnerName',
          'status',
          'hiddenReason',
        ],
      );
      final val = AdminReviewOut(
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
        id: $checkedConvert('id', (v) => v as String),
        bookingId: $checkedConvert('bookingId', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
        partnerId: $checkedConvert('partnerId', (v) => v as String),
        partnerName: $checkedConvert('partnerName', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        hiddenReason: $checkedConvert('hiddenReason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdminReviewOutToJson(AdminReviewOut instance) =>
    <String, dynamic>{
      'stars': instance.stars,
      'tags': instance.tags,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'bookingId': instance.bookingId,
      'code': instance.code,
      'partnerId': instance.partnerId,
      'partnerName': instance.partnerName,
      'status': instance.status,
      'hiddenReason': instance.hiddenReason,
    };

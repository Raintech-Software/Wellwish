// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TicketOutCWProxy {
  TicketOut id(String id);

  TicketOut text(String text);

  TicketOut status(String status);

  TicketOut replies(List<TicketReplyOut> replies);

  TicketOut createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TicketOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TicketOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TicketOut call({
    String id,
    String text,
    String status,
    List<TicketReplyOut> replies,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTicketOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTicketOut.copyWith.fieldName(...)`
class _$TicketOutCWProxyImpl implements _$TicketOutCWProxy {
  const _$TicketOutCWProxyImpl(this._value);

  final TicketOut _value;

  @override
  TicketOut id(String id) => this(id: id);

  @override
  TicketOut text(String text) => this(text: text);

  @override
  TicketOut status(String status) => this(status: status);

  @override
  TicketOut replies(List<TicketReplyOut> replies) => this(replies: replies);

  @override
  TicketOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TicketOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TicketOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TicketOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? replies = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return TicketOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      replies: replies == const $CopyWithPlaceholder()
          ? _value.replies
          // ignore: cast_nullable_to_non_nullable
          : replies as List<TicketReplyOut>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $TicketOutCopyWith on TicketOut {
  /// Returns a callable class that can be used as follows: `instanceOfTicketOut.copyWith(...)` or like so:`instanceOfTicketOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TicketOutCWProxy get copyWith => _$TicketOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketOut _$TicketOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TicketOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'text', 'status', 'replies', 'createdAt'],
      );
      final val = TicketOut(
        id: $checkedConvert('id', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        replies: $checkedConvert(
          'replies',
          (v) => (v as List<dynamic>)
              .map((e) => TicketReplyOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TicketOutToJson(TicketOut instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'status': instance.status,
  'replies': instance.replies.map((e) => e.toJson()).toList(),
  'createdAt': instance.createdAt.toIso8601String(),
};

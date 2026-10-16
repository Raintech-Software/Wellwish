// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationOutCWProxy {
  NotificationOut id(String id);

  NotificationOut type(String type);

  NotificationOut title(String title);

  NotificationOut body(String body);

  NotificationOut data(Map<String, String> data);

  NotificationOut createdAt(DateTime createdAt);

  NotificationOut readAt(DateTime? readAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationOut(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationOut call({
    String id,
    String type,
    String title,
    String body,
    Map<String, String> data,
    DateTime createdAt,
    DateTime? readAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotificationOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotificationOut.copyWith.fieldName(...)`
class _$NotificationOutCWProxyImpl implements _$NotificationOutCWProxy {
  const _$NotificationOutCWProxyImpl(this._value);

  final NotificationOut _value;

  @override
  NotificationOut id(String id) => this(id: id);

  @override
  NotificationOut type(String type) => this(type: type);

  @override
  NotificationOut title(String title) => this(title: title);

  @override
  NotificationOut body(String body) => this(body: body);

  @override
  NotificationOut data(Map<String, String> data) => this(data: data);

  @override
  NotificationOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  NotificationOut readAt(DateTime? readAt) => this(readAt: readAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationOut(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? readAt = const $CopyWithPlaceholder(),
  }) {
    return NotificationOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as Map<String, String>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      readAt: readAt == const $CopyWithPlaceholder()
          ? _value.readAt
          // ignore: cast_nullable_to_non_nullable
          : readAt as DateTime?,
    );
  }
}

extension $NotificationOutCopyWith on NotificationOut {
  /// Returns a callable class that can be used as follows: `instanceOfNotificationOut.copyWith(...)` or like so:`instanceOfNotificationOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationOutCWProxy get copyWith => _$NotificationOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationOut _$NotificationOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('NotificationOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'type',
      'title',
      'body',
      'data',
      'createdAt',
      'readAt',
    ],
  );
  final val = NotificationOut(
    id: $checkedConvert('id', (v) => v as String),
    type: $checkedConvert('type', (v) => v as String),
    title: $checkedConvert('title', (v) => v as String),
    body: $checkedConvert('body', (v) => v as String),
    data: $checkedConvert('data', (v) => Map<String, String>.from(v as Map)),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    readAt: $checkedConvert(
      'readAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$NotificationOutToJson(NotificationOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'createdAt': instance.createdAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };

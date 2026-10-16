// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_count_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UnreadCountOutCWProxy {
  UnreadCountOut unread(int unread);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UnreadCountOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UnreadCountOut(...).copyWith(id: 12, name: "My name")
  /// ````
  UnreadCountOut call({int unread});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUnreadCountOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUnreadCountOut.copyWith.fieldName(...)`
class _$UnreadCountOutCWProxyImpl implements _$UnreadCountOutCWProxy {
  const _$UnreadCountOutCWProxyImpl(this._value);

  final UnreadCountOut _value;

  @override
  UnreadCountOut unread(int unread) => this(unread: unread);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UnreadCountOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UnreadCountOut(...).copyWith(id: 12, name: "My name")
  /// ````
  UnreadCountOut call({Object? unread = const $CopyWithPlaceholder()}) {
    return UnreadCountOut(
      unread: unread == const $CopyWithPlaceholder()
          ? _value.unread
          // ignore: cast_nullable_to_non_nullable
          : unread as int,
    );
  }
}

extension $UnreadCountOutCopyWith on UnreadCountOut {
  /// Returns a callable class that can be used as follows: `instanceOfUnreadCountOut.copyWith(...)` or like so:`instanceOfUnreadCountOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UnreadCountOutCWProxy get copyWith => _$UnreadCountOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountOut _$UnreadCountOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UnreadCountOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['unread']);
      final val = UnreadCountOut(
        unread: $checkedConvert('unread', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$UnreadCountOutToJson(UnreadCountOut instance) =>
    <String, dynamic>{'unread': instance.unread};

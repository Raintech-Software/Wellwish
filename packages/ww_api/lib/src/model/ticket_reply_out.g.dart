// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_reply_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TicketReplyOutCWProxy {
  TicketReplyOut by(String by);

  TicketReplyOut name(String name);

  TicketReplyOut text(String text);

  TicketReplyOut at(DateTime at);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TicketReplyOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TicketReplyOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TicketReplyOut call({String by, String name, String text, DateTime at});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTicketReplyOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTicketReplyOut.copyWith.fieldName(...)`
class _$TicketReplyOutCWProxyImpl implements _$TicketReplyOutCWProxy {
  const _$TicketReplyOutCWProxyImpl(this._value);

  final TicketReplyOut _value;

  @override
  TicketReplyOut by(String by) => this(by: by);

  @override
  TicketReplyOut name(String name) => this(name: name);

  @override
  TicketReplyOut text(String text) => this(text: text);

  @override
  TicketReplyOut at(DateTime at) => this(at: at);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TicketReplyOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TicketReplyOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TicketReplyOut call({
    Object? by = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
  }) {
    return TicketReplyOut(
      by: by == const $CopyWithPlaceholder()
          ? _value.by
          // ignore: cast_nullable_to_non_nullable
          : by as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
    );
  }
}

extension $TicketReplyOutCopyWith on TicketReplyOut {
  /// Returns a callable class that can be used as follows: `instanceOfTicketReplyOut.copyWith(...)` or like so:`instanceOfTicketReplyOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TicketReplyOutCWProxy get copyWith => _$TicketReplyOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketReplyOut _$TicketReplyOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TicketReplyOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['by', 'name', 'text', 'at']);
      final val = TicketReplyOut(
        by: $checkedConvert('by', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$TicketReplyOutToJson(TicketReplyOut instance) =>
    <String, dynamic>{
      'by': instance.by,
      'name': instance.name,
      'text': instance.text,
      'at': instance.at.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_reply_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TicketReplyInCWProxy {
  TicketReplyIn text(String text);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TicketReplyIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TicketReplyIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TicketReplyIn call({String text});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTicketReplyIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTicketReplyIn.copyWith.fieldName(...)`
class _$TicketReplyInCWProxyImpl implements _$TicketReplyInCWProxy {
  const _$TicketReplyInCWProxyImpl(this._value);

  final TicketReplyIn _value;

  @override
  TicketReplyIn text(String text) => this(text: text);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TicketReplyIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TicketReplyIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TicketReplyIn call({Object? text = const $CopyWithPlaceholder()}) {
    return TicketReplyIn(
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
    );
  }
}

extension $TicketReplyInCopyWith on TicketReplyIn {
  /// Returns a callable class that can be used as follows: `instanceOfTicketReplyIn.copyWith(...)` or like so:`instanceOfTicketReplyIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TicketReplyInCWProxy get copyWith => _$TicketReplyInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketReplyIn _$TicketReplyInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TicketReplyIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['text']);
      final val = TicketReplyIn(
        text: $checkedConvert('text', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TicketReplyInToJson(TicketReplyIn instance) =>
    <String, dynamic>{'text': instance.text};

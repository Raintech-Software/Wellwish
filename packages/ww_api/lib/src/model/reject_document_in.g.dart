// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_document_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RejectDocumentInCWProxy {
  RejectDocumentIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RejectDocumentIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RejectDocumentIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RejectDocumentIn call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRejectDocumentIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRejectDocumentIn.copyWith.fieldName(...)`
class _$RejectDocumentInCWProxyImpl implements _$RejectDocumentInCWProxy {
  const _$RejectDocumentInCWProxyImpl(this._value);

  final RejectDocumentIn _value;

  @override
  RejectDocumentIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RejectDocumentIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RejectDocumentIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RejectDocumentIn call({Object? reason = const $CopyWithPlaceholder()}) {
    return RejectDocumentIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $RejectDocumentInCopyWith on RejectDocumentIn {
  /// Returns a callable class that can be used as follows: `instanceOfRejectDocumentIn.copyWith(...)` or like so:`instanceOfRejectDocumentIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RejectDocumentInCWProxy get copyWith => _$RejectDocumentInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectDocumentIn _$RejectDocumentInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RejectDocumentIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = RejectDocumentIn(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RejectDocumentInToJson(RejectDocumentIn instance) =>
    <String, dynamic>{'reason': instance.reason};

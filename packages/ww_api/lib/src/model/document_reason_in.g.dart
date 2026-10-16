// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_reason_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocumentReasonInCWProxy {
  DocumentReasonIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentReasonIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentReasonIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentReasonIn call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocumentReasonIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocumentReasonIn.copyWith.fieldName(...)`
class _$DocumentReasonInCWProxyImpl implements _$DocumentReasonInCWProxy {
  const _$DocumentReasonInCWProxyImpl(this._value);

  final DocumentReasonIn _value;

  @override
  DocumentReasonIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentReasonIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentReasonIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentReasonIn call({Object? reason = const $CopyWithPlaceholder()}) {
    return DocumentReasonIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $DocumentReasonInCopyWith on DocumentReasonIn {
  /// Returns a callable class that can be used as follows: `instanceOfDocumentReasonIn.copyWith(...)` or like so:`instanceOfDocumentReasonIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocumentReasonInCWProxy get copyWith => _$DocumentReasonInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentReasonIn _$DocumentReasonInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DocumentReasonIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = DocumentReasonIn(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DocumentReasonInToJson(DocumentReasonIn instance) =>
    <String, dynamic>{'reason': instance.reason};

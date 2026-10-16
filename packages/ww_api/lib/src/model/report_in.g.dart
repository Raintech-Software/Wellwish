// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportInCWProxy {
  ReportIn text(String text);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportIn call({String text});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportIn.copyWith.fieldName(...)`
class _$ReportInCWProxyImpl implements _$ReportInCWProxy {
  const _$ReportInCWProxyImpl(this._value);

  final ReportIn _value;

  @override
  ReportIn text(String text) => this(text: text);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportIn call({Object? text = const $CopyWithPlaceholder()}) {
    return ReportIn(
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
    );
  }
}

extension $ReportInCopyWith on ReportIn {
  /// Returns a callable class that can be used as follows: `instanceOfReportIn.copyWith(...)` or like so:`instanceOfReportIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportInCWProxy get copyWith => _$ReportInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportIn _$ReportInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['text']);
      final val = ReportIn(text: $checkedConvert('text', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$ReportInToJson(ReportIn instance) => <String, dynamic>{
  'text': instance.text,
};

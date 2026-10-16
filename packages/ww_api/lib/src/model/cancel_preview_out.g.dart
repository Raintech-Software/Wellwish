// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_preview_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CancelPreviewOutCWProxy {
  CancelPreviewOut allowed(bool allowed);

  CancelPreviewOut paidPaise(int paidPaise);

  CancelPreviewOut refundPercent(int refundPercent);

  CancelPreviewOut refundPaise(int refundPaise);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancelPreviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancelPreviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  CancelPreviewOut call({
    bool allowed,
    int paidPaise,
    int refundPercent,
    int refundPaise,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCancelPreviewOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCancelPreviewOut.copyWith.fieldName(...)`
class _$CancelPreviewOutCWProxyImpl implements _$CancelPreviewOutCWProxy {
  const _$CancelPreviewOutCWProxyImpl(this._value);

  final CancelPreviewOut _value;

  @override
  CancelPreviewOut allowed(bool allowed) => this(allowed: allowed);

  @override
  CancelPreviewOut paidPaise(int paidPaise) => this(paidPaise: paidPaise);

  @override
  CancelPreviewOut refundPercent(int refundPercent) =>
      this(refundPercent: refundPercent);

  @override
  CancelPreviewOut refundPaise(int refundPaise) =>
      this(refundPaise: refundPaise);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancelPreviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancelPreviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  CancelPreviewOut call({
    Object? allowed = const $CopyWithPlaceholder(),
    Object? paidPaise = const $CopyWithPlaceholder(),
    Object? refundPercent = const $CopyWithPlaceholder(),
    Object? refundPaise = const $CopyWithPlaceholder(),
  }) {
    return CancelPreviewOut(
      allowed: allowed == const $CopyWithPlaceholder()
          ? _value.allowed
          // ignore: cast_nullable_to_non_nullable
          : allowed as bool,
      paidPaise: paidPaise == const $CopyWithPlaceholder()
          ? _value.paidPaise
          // ignore: cast_nullable_to_non_nullable
          : paidPaise as int,
      refundPercent: refundPercent == const $CopyWithPlaceholder()
          ? _value.refundPercent
          // ignore: cast_nullable_to_non_nullable
          : refundPercent as int,
      refundPaise: refundPaise == const $CopyWithPlaceholder()
          ? _value.refundPaise
          // ignore: cast_nullable_to_non_nullable
          : refundPaise as int,
    );
  }
}

extension $CancelPreviewOutCopyWith on CancelPreviewOut {
  /// Returns a callable class that can be used as follows: `instanceOfCancelPreviewOut.copyWith(...)` or like so:`instanceOfCancelPreviewOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CancelPreviewOutCWProxy get copyWith => _$CancelPreviewOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelPreviewOut _$CancelPreviewOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CancelPreviewOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'allowed',
          'paidPaise',
          'refundPercent',
          'refundPaise',
        ],
      );
      final val = CancelPreviewOut(
        allowed: $checkedConvert('allowed', (v) => v as bool),
        paidPaise: $checkedConvert('paidPaise', (v) => (v as num).toInt()),
        refundPercent: $checkedConvert(
          'refundPercent',
          (v) => (v as num).toInt(),
        ),
        refundPaise: $checkedConvert('refundPaise', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$CancelPreviewOutToJson(CancelPreviewOut instance) =>
    <String, dynamic>{
      'allowed': instance.allowed,
      'paidPaise': instance.paidPaise,
      'refundPercent': instance.refundPercent,
      'refundPaise': instance.refundPaise,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applications_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApplicationsOutCWProxy {
  ApplicationsOut waiting(int waiting);

  ApplicationsOut oldestAt(DateTime? oldestAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationsOut call({int waiting, DateTime? oldestAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApplicationsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApplicationsOut.copyWith.fieldName(...)`
class _$ApplicationsOutCWProxyImpl implements _$ApplicationsOutCWProxy {
  const _$ApplicationsOutCWProxyImpl(this._value);

  final ApplicationsOut _value;

  @override
  ApplicationsOut waiting(int waiting) => this(waiting: waiting);

  @override
  ApplicationsOut oldestAt(DateTime? oldestAt) => this(oldestAt: oldestAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationsOut call({
    Object? waiting = const $CopyWithPlaceholder(),
    Object? oldestAt = const $CopyWithPlaceholder(),
  }) {
    return ApplicationsOut(
      waiting: waiting == const $CopyWithPlaceholder()
          ? _value.waiting
          // ignore: cast_nullable_to_non_nullable
          : waiting as int,
      oldestAt: oldestAt == const $CopyWithPlaceholder()
          ? _value.oldestAt
          // ignore: cast_nullable_to_non_nullable
          : oldestAt as DateTime?,
    );
  }
}

extension $ApplicationsOutCopyWith on ApplicationsOut {
  /// Returns a callable class that can be used as follows: `instanceOfApplicationsOut.copyWith(...)` or like so:`instanceOfApplicationsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApplicationsOutCWProxy get copyWith => _$ApplicationsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationsOut _$ApplicationsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApplicationsOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['waiting']);
      final val = ApplicationsOut(
        waiting: $checkedConvert('waiting', (v) => (v as num).toInt()),
        oldestAt: $checkedConvert(
          'oldestAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ApplicationsOutToJson(ApplicationsOut instance) =>
    <String, dynamic>{
      'waiting': instance.waiting,
      'oldestAt': ?instance.oldestAt?.toIso8601String(),
    };

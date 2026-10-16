// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HealthOutCWProxy {
  HealthOut status(String status);

  HealthOut db(String db);

  HealthOut redis(String redis);

  HealthOut env(String env);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthOut(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthOut call({String status, String db, String redis, String env});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHealthOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHealthOut.copyWith.fieldName(...)`
class _$HealthOutCWProxyImpl implements _$HealthOutCWProxy {
  const _$HealthOutCWProxyImpl(this._value);

  final HealthOut _value;

  @override
  HealthOut status(String status) => this(status: status);

  @override
  HealthOut db(String db) => this(db: db);

  @override
  HealthOut redis(String redis) => this(redis: redis);

  @override
  HealthOut env(String env) => this(env: env);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HealthOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HealthOut(...).copyWith(id: 12, name: "My name")
  /// ````
  HealthOut call({
    Object? status = const $CopyWithPlaceholder(),
    Object? db = const $CopyWithPlaceholder(),
    Object? redis = const $CopyWithPlaceholder(),
    Object? env = const $CopyWithPlaceholder(),
  }) {
    return HealthOut(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      db: db == const $CopyWithPlaceholder()
          ? _value.db
          // ignore: cast_nullable_to_non_nullable
          : db as String,
      redis: redis == const $CopyWithPlaceholder()
          ? _value.redis
          // ignore: cast_nullable_to_non_nullable
          : redis as String,
      env: env == const $CopyWithPlaceholder()
          ? _value.env
          // ignore: cast_nullable_to_non_nullable
          : env as String,
    );
  }
}

extension $HealthOutCopyWith on HealthOut {
  /// Returns a callable class that can be used as follows: `instanceOfHealthOut.copyWith(...)` or like so:`instanceOfHealthOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HealthOutCWProxy get copyWith => _$HealthOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthOut _$HealthOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HealthOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['status', 'db', 'redis', 'env']);
      final val = HealthOut(
        status: $checkedConvert('status', (v) => v as String),
        db: $checkedConvert('db', (v) => v as String),
        redis: $checkedConvert('redis', (v) => v as String),
        env: $checkedConvert('env', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$HealthOutToJson(HealthOut instance) => <String, dynamic>{
  'status': instance.status,
  'db': instance.db,
  'redis': instance.redis,
  'env': instance.env,
};

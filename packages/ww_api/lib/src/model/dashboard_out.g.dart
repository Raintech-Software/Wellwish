// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DashboardOutCWProxy {
  DashboardOut date(DateTime date);

  DashboardOut bookings(TodayBookingsOut? bookings);

  DashboardOut fees(TodayFeesOut? fees);

  DashboardOut applications(ApplicationsOut? applications);

  DashboardOut alerts(AlertsOut? alerts);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardOut call({
    DateTime date,
    TodayBookingsOut? bookings,
    TodayFeesOut? fees,
    ApplicationsOut? applications,
    AlertsOut? alerts,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDashboardOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDashboardOut.copyWith.fieldName(...)`
class _$DashboardOutCWProxyImpl implements _$DashboardOutCWProxy {
  const _$DashboardOutCWProxyImpl(this._value);

  final DashboardOut _value;

  @override
  DashboardOut date(DateTime date) => this(date: date);

  @override
  DashboardOut bookings(TodayBookingsOut? bookings) => this(bookings: bookings);

  @override
  DashboardOut fees(TodayFeesOut? fees) => this(fees: fees);

  @override
  DashboardOut applications(ApplicationsOut? applications) =>
      this(applications: applications);

  @override
  DashboardOut alerts(AlertsOut? alerts) => this(alerts: alerts);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardOut call({
    Object? date = const $CopyWithPlaceholder(),
    Object? bookings = const $CopyWithPlaceholder(),
    Object? fees = const $CopyWithPlaceholder(),
    Object? applications = const $CopyWithPlaceholder(),
    Object? alerts = const $CopyWithPlaceholder(),
  }) {
    return DashboardOut(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime,
      bookings: bookings == const $CopyWithPlaceholder()
          ? _value.bookings
          // ignore: cast_nullable_to_non_nullable
          : bookings as TodayBookingsOut?,
      fees: fees == const $CopyWithPlaceholder()
          ? _value.fees
          // ignore: cast_nullable_to_non_nullable
          : fees as TodayFeesOut?,
      applications: applications == const $CopyWithPlaceholder()
          ? _value.applications
          // ignore: cast_nullable_to_non_nullable
          : applications as ApplicationsOut?,
      alerts: alerts == const $CopyWithPlaceholder()
          ? _value.alerts
          // ignore: cast_nullable_to_non_nullable
          : alerts as AlertsOut?,
    );
  }
}

extension $DashboardOutCopyWith on DashboardOut {
  /// Returns a callable class that can be used as follows: `instanceOfDashboardOut.copyWith(...)` or like so:`instanceOfDashboardOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DashboardOutCWProxy get copyWith => _$DashboardOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardOut _$DashboardOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DashboardOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['date']);
      final val = DashboardOut(
        date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        bookings: $checkedConvert(
          'bookings',
          (v) => v == null
              ? null
              : TodayBookingsOut.fromJson(v as Map<String, dynamic>),
        ),
        fees: $checkedConvert(
          'fees',
          (v) => v == null
              ? null
              : TodayFeesOut.fromJson(v as Map<String, dynamic>),
        ),
        applications: $checkedConvert(
          'applications',
          (v) => v == null
              ? null
              : ApplicationsOut.fromJson(v as Map<String, dynamic>),
        ),
        alerts: $checkedConvert(
          'alerts',
          (v) =>
              v == null ? null : AlertsOut.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DashboardOutToJson(DashboardOut instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'bookings': ?instance.bookings?.toJson(),
      'fees': ?instance.fees?.toJson(),
      'applications': ?instance.applications?.toJson(),
      'alerts': ?instance.alerts?.toJson(),
    };

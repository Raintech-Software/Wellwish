// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_state_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AssignmentStateOutCWProxy {
  AssignmentStateOut bookingId(String bookingId);

  AssignmentStateOut status(String status);

  AssignmentStateOut deadlineAt(DateTime deadlineAt);

  AssignmentStateOut late_(bool late_);

  AssignmentStateOut canAssign(bool canAssign);

  AssignmentStateOut canUnassign(bool canUnassign);

  AssignmentStateOut currentAssignmentId(String? currentAssignmentId);

  AssignmentStateOut openOffer(OfferOut? openOffer);

  AssignmentStateOut partner(AssignedPartnerBriefOut? partner);

  AssignmentStateOut reconfirmNeeded(bool reconfirmNeeded);

  AssignmentStateOut offers(List<OfferOut> offers);

  AssignmentStateOut alerts(List<AlertOut> alerts);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssignmentStateOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssignmentStateOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AssignmentStateOut call({
    String bookingId,
    String status,
    DateTime deadlineAt,
    bool late_,
    bool canAssign,
    bool canUnassign,
    String? currentAssignmentId,
    OfferOut? openOffer,
    AssignedPartnerBriefOut? partner,
    bool reconfirmNeeded,
    List<OfferOut> offers,
    List<AlertOut> alerts,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAssignmentStateOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAssignmentStateOut.copyWith.fieldName(...)`
class _$AssignmentStateOutCWProxyImpl implements _$AssignmentStateOutCWProxy {
  const _$AssignmentStateOutCWProxyImpl(this._value);

  final AssignmentStateOut _value;

  @override
  AssignmentStateOut bookingId(String bookingId) => this(bookingId: bookingId);

  @override
  AssignmentStateOut status(String status) => this(status: status);

  @override
  AssignmentStateOut deadlineAt(DateTime deadlineAt) =>
      this(deadlineAt: deadlineAt);

  @override
  AssignmentStateOut late_(bool late_) => this(late_: late_);

  @override
  AssignmentStateOut canAssign(bool canAssign) => this(canAssign: canAssign);

  @override
  AssignmentStateOut canUnassign(bool canUnassign) =>
      this(canUnassign: canUnassign);

  @override
  AssignmentStateOut currentAssignmentId(String? currentAssignmentId) =>
      this(currentAssignmentId: currentAssignmentId);

  @override
  AssignmentStateOut openOffer(OfferOut? openOffer) =>
      this(openOffer: openOffer);

  @override
  AssignmentStateOut partner(AssignedPartnerBriefOut? partner) =>
      this(partner: partner);

  @override
  AssignmentStateOut reconfirmNeeded(bool reconfirmNeeded) =>
      this(reconfirmNeeded: reconfirmNeeded);

  @override
  AssignmentStateOut offers(List<OfferOut> offers) => this(offers: offers);

  @override
  AssignmentStateOut alerts(List<AlertOut> alerts) => this(alerts: alerts);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssignmentStateOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssignmentStateOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AssignmentStateOut call({
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? deadlineAt = const $CopyWithPlaceholder(),
    Object? late_ = const $CopyWithPlaceholder(),
    Object? canAssign = const $CopyWithPlaceholder(),
    Object? canUnassign = const $CopyWithPlaceholder(),
    Object? currentAssignmentId = const $CopyWithPlaceholder(),
    Object? openOffer = const $CopyWithPlaceholder(),
    Object? partner = const $CopyWithPlaceholder(),
    Object? reconfirmNeeded = const $CopyWithPlaceholder(),
    Object? offers = const $CopyWithPlaceholder(),
    Object? alerts = const $CopyWithPlaceholder(),
  }) {
    return AssignmentStateOut(
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      deadlineAt: deadlineAt == const $CopyWithPlaceholder()
          ? _value.deadlineAt
          // ignore: cast_nullable_to_non_nullable
          : deadlineAt as DateTime,
      late_: late_ == const $CopyWithPlaceholder()
          ? _value.late_
          // ignore: cast_nullable_to_non_nullable
          : late_ as bool,
      canAssign: canAssign == const $CopyWithPlaceholder()
          ? _value.canAssign
          // ignore: cast_nullable_to_non_nullable
          : canAssign as bool,
      canUnassign: canUnassign == const $CopyWithPlaceholder()
          ? _value.canUnassign
          // ignore: cast_nullable_to_non_nullable
          : canUnassign as bool,
      currentAssignmentId: currentAssignmentId == const $CopyWithPlaceholder()
          ? _value.currentAssignmentId
          // ignore: cast_nullable_to_non_nullable
          : currentAssignmentId as String?,
      openOffer: openOffer == const $CopyWithPlaceholder()
          ? _value.openOffer
          // ignore: cast_nullable_to_non_nullable
          : openOffer as OfferOut?,
      partner: partner == const $CopyWithPlaceholder()
          ? _value.partner
          // ignore: cast_nullable_to_non_nullable
          : partner as AssignedPartnerBriefOut?,
      reconfirmNeeded: reconfirmNeeded == const $CopyWithPlaceholder()
          ? _value.reconfirmNeeded
          // ignore: cast_nullable_to_non_nullable
          : reconfirmNeeded as bool,
      offers: offers == const $CopyWithPlaceholder()
          ? _value.offers
          // ignore: cast_nullable_to_non_nullable
          : offers as List<OfferOut>,
      alerts: alerts == const $CopyWithPlaceholder()
          ? _value.alerts
          // ignore: cast_nullable_to_non_nullable
          : alerts as List<AlertOut>,
    );
  }
}

extension $AssignmentStateOutCopyWith on AssignmentStateOut {
  /// Returns a callable class that can be used as follows: `instanceOfAssignmentStateOut.copyWith(...)` or like so:`instanceOfAssignmentStateOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AssignmentStateOutCWProxy get copyWith =>
      _$AssignmentStateOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignmentStateOut _$AssignmentStateOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AssignmentStateOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'bookingId',
          'status',
          'deadlineAt',
          'late',
          'canAssign',
          'canUnassign',
          'currentAssignmentId',
          'openOffer',
          'partner',
          'reconfirmNeeded',
          'offers',
          'alerts',
        ],
      );
      final val = AssignmentStateOut(
        bookingId: $checkedConvert('bookingId', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        deadlineAt: $checkedConvert(
          'deadlineAt',
          (v) => DateTime.parse(v as String),
        ),
        late_: $checkedConvert('late', (v) => v as bool),
        canAssign: $checkedConvert('canAssign', (v) => v as bool),
        canUnassign: $checkedConvert('canUnassign', (v) => v as bool),
        currentAssignmentId: $checkedConvert(
          'currentAssignmentId',
          (v) => v as String?,
        ),
        openOffer: $checkedConvert(
          'openOffer',
          (v) =>
              v == null ? null : OfferOut.fromJson(v as Map<String, dynamic>),
        ),
        partner: $checkedConvert(
          'partner',
          (v) => v == null
              ? null
              : AssignedPartnerBriefOut.fromJson(v as Map<String, dynamic>),
        ),
        reconfirmNeeded: $checkedConvert('reconfirmNeeded', (v) => v as bool),
        offers: $checkedConvert(
          'offers',
          (v) => (v as List<dynamic>)
              .map((e) => OfferOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        alerts: $checkedConvert(
          'alerts',
          (v) => (v as List<dynamic>)
              .map((e) => AlertOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'late_': 'late'});

Map<String, dynamic> _$AssignmentStateOutToJson(AssignmentStateOut instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'status': instance.status,
      'deadlineAt': instance.deadlineAt.toIso8601String(),
      'late': instance.late_,
      'canAssign': instance.canAssign,
      'canUnassign': instance.canUnassign,
      'currentAssignmentId': instance.currentAssignmentId,
      'openOffer': instance.openOffer?.toJson(),
      'partner': instance.partner?.toJson(),
      'reconfirmNeeded': instance.reconfirmNeeded,
      'offers': instance.offers.map((e) => e.toJson()).toList(),
      'alerts': instance.alerts.map((e) => e.toJson()).toList(),
    };

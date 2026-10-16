//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/today_bookings_out.dart';
import 'package:ww_api/src/model/today_fees_out.dart';
import 'package:ww_api/src/model/applications_out.dart';
import 'package:ww_api/src/model/alerts_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DashboardOut {
  /// Returns a new [DashboardOut] instance.
  DashboardOut({

    required  this.date,

     this.bookings,

     this.fees,

     this.applications,

     this.alerts,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final DateTime date;



      /// bookings.view
  @JsonKey(
    
    name: r'bookings',
    required: false,
    includeIfNull: false,
  )


  final TodayBookingsOut? bookings;



      /// payments.view
  @JsonKey(
    
    name: r'fees',
    required: false,
    includeIfNull: false,
  )


  final TodayFeesOut? fees;



      /// partners.review
  @JsonKey(
    
    name: r'applications',
    required: false,
    includeIfNull: false,
  )


  final ApplicationsOut? applications;



      /// bookings.view or live.view
  @JsonKey(
    
    name: r'alerts',
    required: false,
    includeIfNull: false,
  )


  final AlertsOut? alerts;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DashboardOut &&
      other.date == date &&
      other.bookings == bookings &&
      other.fees == fees &&
      other.applications == applications &&
      other.alerts == alerts;

    @override
    int get hashCode =>
        date.hashCode +
        (bookings == null ? 0 : bookings.hashCode) +
        (fees == null ? 0 : fees.hashCode) +
        (applications == null ? 0 : applications.hashCode) +
        (alerts == null ? 0 : alerts.hashCode);

  factory DashboardOut.fromJson(Map<String, dynamic> json) => _$DashboardOutFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


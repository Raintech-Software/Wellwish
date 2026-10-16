//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/offer_summary_out.dart';
import 'package:ww_api/src/model/partner_job_row_out.dart';
import 'package:ww_api/src/model/partner_totals_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_home_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerHomeOut {
  /// Returns a new [PartnerHomeOut] instance.
  PartnerHomeOut({

    required  this.availableToday,

    required  this.selfieToday,

    required  this.offers,

    required  this.today,

    required  this.totals,
  });

  @JsonKey(
    
    name: r'availableToday',
    required: true,
    includeIfNull: false,
  )


  final bool availableToday;



  @JsonKey(
    
    name: r'selfieToday',
    required: true,
    includeIfNull: false,
  )


  final bool selfieToday;



  @JsonKey(
    
    name: r'offers',
    required: true,
    includeIfNull: false,
  )


  final List<OfferSummaryOut> offers;



  @JsonKey(
    
    name: r'today',
    required: true,
    includeIfNull: false,
  )


  final List<PartnerJobRowOut> today;



  @JsonKey(
    
    name: r'totals',
    required: true,
    includeIfNull: false,
  )


  final PartnerTotalsOut totals;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerHomeOut &&
      other.availableToday == availableToday &&
      other.selfieToday == selfieToday &&
      other.offers == offers &&
      other.today == today &&
      other.totals == totals;

    @override
    int get hashCode =>
        availableToday.hashCode +
        selfieToday.hashCode +
        offers.hashCode +
        today.hashCode +
        totals.hashCode;

  factory PartnerHomeOut.fromJson(Map<String, dynamic> json) => _$PartnerHomeOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerHomeOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


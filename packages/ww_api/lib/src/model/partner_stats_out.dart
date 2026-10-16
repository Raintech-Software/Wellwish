//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/partner_review_out.dart';
import 'package:ww_api/src/model/job_counts_out.dart';
import 'package:ww_api/src/model/balance_sum_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_stats_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerStatsOut {
  /// Returns a new [PartnerStatsOut] instance.
  PartnerStatsOut({

    required  this.jobs,

    required  this.balanceWeek,

    required  this.balanceMonth,

    required  this.balanceAll,

    required  this.offersReceived,

    required  this.offersAccepted,

    required  this.offersDeclined,

    required  this.offersNotAnswered,

    required  this.ratingAvg,

    required  this.ratingCount,

    required  this.recentReviews,

    required  this.upcoming,
  });

  @JsonKey(
    
    name: r'jobs',
    required: true,
    includeIfNull: false,
  )


  final JobCountsOut jobs;



  @JsonKey(
    
    name: r'balanceWeek',
    required: true,
    includeIfNull: false,
  )


  final BalanceSumOut balanceWeek;



  @JsonKey(
    
    name: r'balanceMonth',
    required: true,
    includeIfNull: false,
  )


  final BalanceSumOut balanceMonth;



  @JsonKey(
    
    name: r'balanceAll',
    required: true,
    includeIfNull: false,
  )


  final BalanceSumOut balanceAll;



  @JsonKey(
    
    name: r'offersReceived',
    required: true,
    includeIfNull: false,
  )


  final int offersReceived;



  @JsonKey(
    
    name: r'offersAccepted',
    required: true,
    includeIfNull: false,
  )


  final int offersAccepted;



  @JsonKey(
    
    name: r'offersDeclined',
    required: true,
    includeIfNull: false,
  )


  final int offersDeclined;



      /// Not answered within 2 minutes
  @JsonKey(
    
    name: r'offersNotAnswered',
    required: true,
    includeIfNull: false,
  )


  final int offersNotAnswered;



  @JsonKey(
    
    name: r'ratingAvg',
    required: true,
    includeIfNull: true,
  )


  final String? ratingAvg;



  @JsonKey(
    
    name: r'ratingCount',
    required: true,
    includeIfNull: false,
  )


  final int ratingCount;



  @JsonKey(
    
    name: r'recentReviews',
    required: true,
    includeIfNull: false,
  )


  final List<PartnerReviewOut> recentReviews;



  @JsonKey(
    
    name: r'upcoming',
    required: true,
    includeIfNull: false,
  )


  final int upcoming;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerStatsOut &&
      other.jobs == jobs &&
      other.balanceWeek == balanceWeek &&
      other.balanceMonth == balanceMonth &&
      other.balanceAll == balanceAll &&
      other.offersReceived == offersReceived &&
      other.offersAccepted == offersAccepted &&
      other.offersDeclined == offersDeclined &&
      other.offersNotAnswered == offersNotAnswered &&
      other.ratingAvg == ratingAvg &&
      other.ratingCount == ratingCount &&
      other.recentReviews == recentReviews &&
      other.upcoming == upcoming;

    @override
    int get hashCode =>
        jobs.hashCode +
        balanceWeek.hashCode +
        balanceMonth.hashCode +
        balanceAll.hashCode +
        offersReceived.hashCode +
        offersAccepted.hashCode +
        offersDeclined.hashCode +
        offersNotAnswered.hashCode +
        (ratingAvg == null ? 0 : ratingAvg.hashCode) +
        ratingCount.hashCode +
        recentReviews.hashCode +
        upcoming.hashCode;

  factory PartnerStatsOut.fromJson(Map<String, dynamic> json) => _$PartnerStatsOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerStatsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


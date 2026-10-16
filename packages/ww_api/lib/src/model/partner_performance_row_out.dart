//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_performance_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerPerformanceRowOut {
  /// Returns a new [PartnerPerformanceRowOut] instance.
  PartnerPerformanceRowOut({

    required  this.partnerId,

    required  this.name,

    required  this.role,

    required  this.status,

    required  this.jobs,

    required  this.noShow,

    required  this.offersReceived,

    required  this.offersAccepted,

    required  this.offersDeclined,

    required  this.offersNotAnswered,

     this.acceptancePercent,

     this.ratingAvg,

    required  this.ratingCount,
  });

  @JsonKey(
    
    name: r'partnerId',
    required: true,
    includeIfNull: false,
  )


  final String partnerId;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



      /// Visits completed on these dates
  @JsonKey(
    
    name: r'jobs',
    required: true,
    includeIfNull: false,
  )


  final int jobs;



      /// Patient not available
  @JsonKey(
    
    name: r'noShow',
    required: true,
    includeIfNull: false,
  )


  final int noShow;



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



      /// Accepted / received; none: no offers
  @JsonKey(
    
    name: r'acceptancePercent',
    required: false,
    includeIfNull: false,
  )


  final int? acceptancePercent;



  @JsonKey(
    
    name: r'ratingAvg',
    required: false,
    includeIfNull: false,
  )


  final num? ratingAvg;



  @JsonKey(
    
    name: r'ratingCount',
    required: true,
    includeIfNull: false,
  )


  final int ratingCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerPerformanceRowOut &&
      other.partnerId == partnerId &&
      other.name == name &&
      other.role == role &&
      other.status == status &&
      other.jobs == jobs &&
      other.noShow == noShow &&
      other.offersReceived == offersReceived &&
      other.offersAccepted == offersAccepted &&
      other.offersDeclined == offersDeclined &&
      other.offersNotAnswered == offersNotAnswered &&
      other.acceptancePercent == acceptancePercent &&
      other.ratingAvg == ratingAvg &&
      other.ratingCount == ratingCount;

    @override
    int get hashCode =>
        partnerId.hashCode +
        name.hashCode +
        role.hashCode +
        status.hashCode +
        jobs.hashCode +
        noShow.hashCode +
        offersReceived.hashCode +
        offersAccepted.hashCode +
        offersDeclined.hashCode +
        offersNotAnswered.hashCode +
        (acceptancePercent == null ? 0 : acceptancePercent.hashCode) +
        (ratingAvg == null ? 0 : ratingAvg.hashCode) +
        ratingCount.hashCode;

  factory PartnerPerformanceRowOut.fromJson(Map<String, dynamic> json) => _$PartnerPerformanceRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerPerformanceRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


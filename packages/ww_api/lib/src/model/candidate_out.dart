//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'candidate_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CandidateOut {
  /// Returns a new [CandidateOut] instance.
  CandidateOut({

    required  this.partnerId,

    required  this.fullName,

    required  this.photoUrl,

    required  this.gender,

    required  this.languages,

    required  this.skills,

    required  this.ratingAvg,

    required  this.ratingCount,

    required  this.distanceKm,

    required  this.availableToday,

    required  this.jobsThisWeek,

    required  this.phone,

    required  this.alternatePhone,

    required  this.offeredNow,
  });

  @JsonKey(
    
    name: r'partnerId',
    required: true,
    includeIfNull: false,
  )


  final String partnerId;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'photoUrl',
    required: true,
    includeIfNull: true,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'gender',
    required: true,
    includeIfNull: false,
  )


  final String gender;



  @JsonKey(
    
    name: r'languages',
    required: true,
    includeIfNull: false,
  )


  final List<String> languages;



  @JsonKey(
    
    name: r'skills',
    required: true,
    includeIfNull: false,
  )


  final List<String> skills;



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
    
    name: r'distanceKm',
    required: true,
    includeIfNull: true,
  )


  final num? distanceKm;



  @JsonKey(
    
    name: r'availableToday',
    required: true,
    includeIfNull: false,
  )


  final bool availableToday;



  @JsonKey(
    
    name: r'jobsThisWeek',
    required: true,
    includeIfNull: false,
  )


  final int jobsThisWeek;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'alternatePhone',
    required: true,
    includeIfNull: false,
  )


  final String alternatePhone;



  @JsonKey(
    
    name: r'offeredNow',
    required: true,
    includeIfNull: false,
  )


  final bool offeredNow;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CandidateOut &&
      other.partnerId == partnerId &&
      other.fullName == fullName &&
      other.photoUrl == photoUrl &&
      other.gender == gender &&
      other.languages == languages &&
      other.skills == skills &&
      other.ratingAvg == ratingAvg &&
      other.ratingCount == ratingCount &&
      other.distanceKm == distanceKm &&
      other.availableToday == availableToday &&
      other.jobsThisWeek == jobsThisWeek &&
      other.phone == phone &&
      other.alternatePhone == alternatePhone &&
      other.offeredNow == offeredNow;

    @override
    int get hashCode =>
        partnerId.hashCode +
        fullName.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        gender.hashCode +
        languages.hashCode +
        skills.hashCode +
        (ratingAvg == null ? 0 : ratingAvg.hashCode) +
        ratingCount.hashCode +
        (distanceKm == null ? 0 : distanceKm.hashCode) +
        availableToday.hashCode +
        jobsThisWeek.hashCode +
        phone.hashCode +
        alternatePhone.hashCode +
        offeredNow.hashCode;

  factory CandidateOut.fromJson(Map<String, dynamic> json) => _$CandidateOutFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


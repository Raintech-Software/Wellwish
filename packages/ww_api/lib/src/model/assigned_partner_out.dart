//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assigned_partner_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AssignedPartnerOut {
  /// Returns a new [AssignedPartnerOut] instance.
  AssignedPartnerOut({

    required  this.fullName,

    required  this.role,

    required  this.photoUrl,

    required  this.phone,

    required  this.ratingAvg,

    required  this.ratingCount,
  });

  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'photoUrl',
    required: true,
    includeIfNull: true,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is AssignedPartnerOut &&
      other.fullName == fullName &&
      other.role == role &&
      other.photoUrl == photoUrl &&
      other.phone == phone &&
      other.ratingAvg == ratingAvg &&
      other.ratingCount == ratingCount;

    @override
    int get hashCode =>
        fullName.hashCode +
        role.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        phone.hashCode +
        (ratingAvg == null ? 0 : ratingAvg.hashCode) +
        ratingCount.hashCode;

  factory AssignedPartnerOut.fromJson(Map<String, dynamic> json) => _$AssignedPartnerOutFromJson(json);

  Map<String, dynamic> toJson() => _$AssignedPartnerOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


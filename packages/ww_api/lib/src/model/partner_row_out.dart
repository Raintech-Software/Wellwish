//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerRowOut {
  /// Returns a new [PartnerRowOut] instance.
  PartnerRowOut({

    required  this.id,

    required  this.role,

    required  this.status,

    required  this.fullName,

    required  this.phone,

    required  this.alternatePhone,

    required  this.email,

    required  this.availableToday,

    required  this.ratingAvg,

    required  this.addedByAdmin,

    required  this.documentsToReview,

    required  this.createdAt,

     this.deleting = false,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



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
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



  @JsonKey(
    
    name: r'availableToday',
    required: true,
    includeIfNull: false,
  )


  final bool availableToday;



  @JsonKey(
    
    name: r'ratingAvg',
    required: true,
    includeIfNull: true,
  )


  final String? ratingAvg;



  @JsonKey(
    
    name: r'addedByAdmin',
    required: true,
    includeIfNull: false,
  )


  final bool addedByAdmin;



  @JsonKey(
    
    name: r'documentsToReview',
    required: true,
    includeIfNull: false,
  )


  final int documentsToReview;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



      /// Asked to delete their account (§6.20)
  @JsonKey(
    defaultValue: false,
    name: r'deleting',
    required: false,
    includeIfNull: false,
  )


  final bool? deleting;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerRowOut &&
      other.id == id &&
      other.role == role &&
      other.status == status &&
      other.fullName == fullName &&
      other.phone == phone &&
      other.alternatePhone == alternatePhone &&
      other.email == email &&
      other.availableToday == availableToday &&
      other.ratingAvg == ratingAvg &&
      other.addedByAdmin == addedByAdmin &&
      other.documentsToReview == documentsToReview &&
      other.createdAt == createdAt &&
      other.deleting == deleting;

    @override
    int get hashCode =>
        id.hashCode +
        role.hashCode +
        status.hashCode +
        fullName.hashCode +
        phone.hashCode +
        alternatePhone.hashCode +
        email.hashCode +
        availableToday.hashCode +
        (ratingAvg == null ? 0 : ratingAvg.hashCode) +
        addedByAdmin.hashCode +
        documentsToReview.hashCode +
        createdAt.hashCode +
        deleting.hashCode;

  factory PartnerRowOut.fromJson(Map<String, dynamic> json) => _$PartnerRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


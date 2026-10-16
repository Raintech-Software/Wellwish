//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientRowOut {
  /// Returns a new [PatientRowOut] instance.
  PatientRowOut({

    required  this.id,

    required  this.phone,

    required  this.fullName,

    required  this.status,

    required  this.memberCount,

    required  this.createdAt,

    required  this.deletionDueAt,

     this.blockedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'memberCount',
    required: true,
    includeIfNull: false,
  )


  final int memberCount;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'deletionDueAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? deletionDueAt;



      /// blocked from the patient app by an admin (§9.1)
  @JsonKey(
    
    name: r'blockedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? blockedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientRowOut &&
      other.id == id &&
      other.phone == phone &&
      other.fullName == fullName &&
      other.status == status &&
      other.memberCount == memberCount &&
      other.createdAt == createdAt &&
      other.deletionDueAt == deletionDueAt &&
      other.blockedAt == blockedAt;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        fullName.hashCode +
        status.hashCode +
        memberCount.hashCode +
        createdAt.hashCode +
        (deletionDueAt == null ? 0 : deletionDueAt.hashCode) +
        (blockedAt == null ? 0 : blockedAt.hashCode);

  factory PatientRowOut.fromJson(Map<String, dynamic> json) => _$PatientRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$PatientRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


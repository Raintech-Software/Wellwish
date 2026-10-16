//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApplicationRowOut {
  /// Returns a new [ApplicationRowOut] instance.
  ApplicationRowOut({

    required  this.id,

    required  this.partnerId,

    required  this.fullName,

    required  this.role,

    required  this.phone,

    required  this.status,

    required  this.submittedAt,

    required  this.firstSubmittedAt,

    required  this.waitingHours,

    required  this.pendingDocuments,

    required  this.claimedBy,

    required  this.claimedUntil,

    required  this.claimedByMe,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'submittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime submittedAt;



  @JsonKey(
    
    name: r'firstSubmittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime firstSubmittedAt;



  @JsonKey(
    
    name: r'waitingHours',
    required: true,
    includeIfNull: false,
  )


  final int waitingHours;



  @JsonKey(
    
    name: r'pendingDocuments',
    required: true,
    includeIfNull: false,
  )


  final int pendingDocuments;



  @JsonKey(
    
    name: r'claimedBy',
    required: true,
    includeIfNull: true,
  )


  final String? claimedBy;



  @JsonKey(
    
    name: r'claimedUntil',
    required: true,
    includeIfNull: true,
  )


  final DateTime? claimedUntil;



  @JsonKey(
    
    name: r'claimedByMe',
    required: true,
    includeIfNull: false,
  )


  final bool claimedByMe;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApplicationRowOut &&
      other.id == id &&
      other.partnerId == partnerId &&
      other.fullName == fullName &&
      other.role == role &&
      other.phone == phone &&
      other.status == status &&
      other.submittedAt == submittedAt &&
      other.firstSubmittedAt == firstSubmittedAt &&
      other.waitingHours == waitingHours &&
      other.pendingDocuments == pendingDocuments &&
      other.claimedBy == claimedBy &&
      other.claimedUntil == claimedUntil &&
      other.claimedByMe == claimedByMe;

    @override
    int get hashCode =>
        id.hashCode +
        partnerId.hashCode +
        fullName.hashCode +
        role.hashCode +
        phone.hashCode +
        status.hashCode +
        submittedAt.hashCode +
        firstSubmittedAt.hashCode +
        waitingHours.hashCode +
        pendingDocuments.hashCode +
        (claimedBy == null ? 0 : claimedBy.hashCode) +
        (claimedUntil == null ? 0 : claimedUntil.hashCode) +
        claimedByMe.hashCode;

  factory ApplicationRowOut.fromJson(Map<String, dynamic> json) => _$ApplicationRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


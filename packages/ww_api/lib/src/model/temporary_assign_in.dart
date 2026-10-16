//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temporary_assign_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TemporaryAssignIn {
  /// Returns a new [TemporaryAssignIn] instance.
  TemporaryAssignIn({

    required  this.phone,

    required  this.fullName,

    required  this.gender,

    required  this.idType,

    required  this.idLast4,

    required  this.idPhotoKey,

     this.nursingRegNo = '',

    required  this.reason,

    required  this.idChecked,

    required  this.expectedAssignmentId,
  });

      /// Their mobile: the partner app login
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
    
    name: r'gender',
    required: true,
    includeIfNull: false,
  )


  final TemporaryAssignInGenderEnum gender;



  @JsonKey(
    
    name: r'idType',
    required: true,
    includeIfNull: false,
  )


  final TemporaryAssignInIdTypeEnum idType;



      /// The last 4 characters only, never more
  @JsonKey(
    
    name: r'idLast4',
    required: true,
    includeIfNull: false,
  )


  final String idLast4;



      /// From /admin/files/upload-url, purpose temp_partner_id
  @JsonKey(
    
    name: r'idPhotoKey',
    required: true,
    includeIfNull: false,
  )


  final String idPhotoKey;



      /// Nurse bookings: as printed
  @JsonKey(
    defaultValue: '',
    name: r'nursingRegNo',
    required: false,
    includeIfNull: false,
  )


  final String? nursingRegNo;



      /// Why no regular partner could take it
  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



      /// \"I've called this person and checked their ID against the photo\"
  @JsonKey(
    
    name: r'idChecked',
    required: true,
    includeIfNull: false,
  )


  final bool idChecked;



      /// The open offer the admin saw (null: none)
  @JsonKey(
    
    name: r'expectedAssignmentId',
    required: true,
    includeIfNull: true,
  )


  final String? expectedAssignmentId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TemporaryAssignIn &&
      other.phone == phone &&
      other.fullName == fullName &&
      other.gender == gender &&
      other.idType == idType &&
      other.idLast4 == idLast4 &&
      other.idPhotoKey == idPhotoKey &&
      other.nursingRegNo == nursingRegNo &&
      other.reason == reason &&
      other.idChecked == idChecked &&
      other.expectedAssignmentId == expectedAssignmentId;

    @override
    int get hashCode =>
        phone.hashCode +
        fullName.hashCode +
        gender.hashCode +
        idType.hashCode +
        idLast4.hashCode +
        idPhotoKey.hashCode +
        nursingRegNo.hashCode +
        reason.hashCode +
        idChecked.hashCode +
        (expectedAssignmentId == null ? 0 : expectedAssignmentId.hashCode);

  factory TemporaryAssignIn.fromJson(Map<String, dynamic> json) => _$TemporaryAssignInFromJson(json);

  Map<String, dynamic> toJson() => _$TemporaryAssignInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TemporaryAssignInGenderEnum {
@JsonValue(r'FEMALE')
FEMALE(r'FEMALE'),
@JsonValue(r'MALE')
MALE(r'MALE'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const TemporaryAssignInGenderEnum(this.value);

final String value;

@override
String toString() => value;
}


enum TemporaryAssignInIdTypeEnum {
@JsonValue(r'AADHAAR')
AADHAAR(r'AADHAAR'),
@JsonValue(r'DRIVING_LICENCE')
DRIVING_LICENCE(r'DRIVING_LICENCE'),
@JsonValue(r'VOTER_ID')
VOTER_ID(r'VOTER_ID'),
@JsonValue(r'PAN')
PAN(r'PAN');

const TemporaryAssignInIdTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



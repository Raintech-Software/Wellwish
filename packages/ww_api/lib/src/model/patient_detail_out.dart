//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/patient_row_out.dart';
import 'package:ww_api/src/model/address_out.dart';
import 'package:ww_api/src/model/admin_booking_row_out.dart';
import 'package:ww_api/src/model/patient_document_out.dart';
import 'package:ww_api/src/model/admin_member_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_detail_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientDetailOut {
  /// Returns a new [PatientDetailOut] instance.
  PatientDetailOut({

    required  this.patient,

    required  this.dob,

    required  this.gender,

    required  this.language,

    required  this.members,

    required  this.addresses,

    required  this.documentsVisible,

    required  this.documents,

    required  this.bookingsVisible,

    required  this.bookings,

     this.blockedReason = '',
  });

  @JsonKey(
    
    name: r'patient',
    required: true,
    includeIfNull: false,
  )


  final PatientRowOut patient;



  @JsonKey(
    
    name: r'dob',
    required: true,
    includeIfNull: true,
  )


  final DateTime? dob;



  @JsonKey(
    
    name: r'gender',
    required: true,
    includeIfNull: false,
  )


  final String gender;



  @JsonKey(
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final String language;



  @JsonKey(
    
    name: r'members',
    required: true,
    includeIfNull: false,
  )


  final List<AdminMemberOut> members;



  @JsonKey(
    
    name: r'addresses',
    required: true,
    includeIfNull: false,
  )


  final List<AddressOut> addresses;



      /// false: this role may not see patient documents (§9.2)
  @JsonKey(
    
    name: r'documentsVisible',
    required: true,
    includeIfNull: false,
  )


  final bool documentsVisible;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<PatientDocumentOut> documents;



      /// false: this role may not see bookings
  @JsonKey(
    
    name: r'bookingsVisible',
    required: true,
    includeIfNull: false,
  )


  final bool bookingsVisible;



      /// Latest first (at most 100)
  @JsonKey(
    
    name: r'bookings',
    required: true,
    includeIfNull: false,
  )


  final List<AdminBookingRowOut> bookings;



      /// why it was blocked (when blocked)
  @JsonKey(
    defaultValue: '',
    name: r'blockedReason',
    required: false,
    includeIfNull: false,
  )


  final String? blockedReason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientDetailOut &&
      other.patient == patient &&
      other.dob == dob &&
      other.gender == gender &&
      other.language == language &&
      other.members == members &&
      other.addresses == addresses &&
      other.documentsVisible == documentsVisible &&
      other.documents == documents &&
      other.bookingsVisible == bookingsVisible &&
      other.bookings == bookings &&
      other.blockedReason == blockedReason;

    @override
    int get hashCode =>
        patient.hashCode +
        (dob == null ? 0 : dob.hashCode) +
        gender.hashCode +
        language.hashCode +
        members.hashCode +
        addresses.hashCode +
        documentsVisible.hashCode +
        documents.hashCode +
        bookingsVisible.hashCode +
        bookings.hashCode +
        blockedReason.hashCode;

  factory PatientDetailOut.fromJson(Map<String, dynamic> json) => _$PatientDetailOutFromJson(json);

  Map<String, dynamic> toJson() => _$PatientDetailOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/member_out.dart';
import 'package:ww_api/src/model/address_out.dart';
import 'package:ww_api/src/model/patient_document_out.dart';
import 'package:ww_api/src/model/booking_row_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_detail_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MemberDetailOut {
  /// Returns a new [MemberDetailOut] instance.
  MemberDetailOut({

    required  this.member,

    required  this.addresses,

    required  this.documents,

    required  this.bookings,
  });

  @JsonKey(
    
    name: r'member',
    required: true,
    includeIfNull: false,
  )


  final MemberOut member;



  @JsonKey(
    
    name: r'addresses',
    required: true,
    includeIfNull: false,
  )


  final List<AddressOut> addresses;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<PatientDocumentOut> documents;



      /// Upcoming (soonest first), then the latest past ones; at most 5
  @JsonKey(
    
    name: r'bookings',
    required: true,
    includeIfNull: false,
  )


  final List<BookingRowOut> bookings;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MemberDetailOut &&
      other.member == member &&
      other.addresses == addresses &&
      other.documents == documents &&
      other.bookings == bookings;

    @override
    int get hashCode =>
        member.hashCode +
        addresses.hashCode +
        documents.hashCode +
        bookings.hashCode;

  factory MemberDetailOut.fromJson(Map<String, dynamic> json) => _$MemberDetailOutFromJson(json);

  Map<String, dynamic> toJson() => _$MemberDetailOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


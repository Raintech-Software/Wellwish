//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/ticket_reply_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_ticket_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminTicketOut {
  /// Returns a new [AdminTicketOut] instance.
  AdminTicketOut({

    required  this.id,

    required  this.text,

    required  this.status,

    required  this.replies,

    required  this.createdAt,

    required  this.bookingId,

    required  this.code,

    required  this.patientName,

    required  this.patientPhone,

    required  this.partnerName,

    required  this.closedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'replies',
    required: true,
    includeIfNull: false,
  )


  final List<TicketReplyOut> replies;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'bookingId',
    required: true,
    includeIfNull: true,
  )


  final String? bookingId;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'patientName',
    required: true,
    includeIfNull: false,
  )


  final String patientName;



  @JsonKey(
    
    name: r'patientPhone',
    required: true,
    includeIfNull: false,
  )


  final String patientPhone;



  @JsonKey(
    
    name: r'partnerName',
    required: true,
    includeIfNull: false,
  )


  final String partnerName;



  @JsonKey(
    
    name: r'closedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? closedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminTicketOut &&
      other.id == id &&
      other.text == text &&
      other.status == status &&
      other.replies == replies &&
      other.createdAt == createdAt &&
      other.bookingId == bookingId &&
      other.code == code &&
      other.patientName == patientName &&
      other.patientPhone == patientPhone &&
      other.partnerName == partnerName &&
      other.closedAt == closedAt;

    @override
    int get hashCode =>
        id.hashCode +
        text.hashCode +
        status.hashCode +
        replies.hashCode +
        createdAt.hashCode +
        (bookingId == null ? 0 : bookingId.hashCode) +
        code.hashCode +
        patientName.hashCode +
        patientPhone.hashCode +
        partnerName.hashCode +
        (closedAt == null ? 0 : closedAt.hashCode);

  factory AdminTicketOut.fromJson(Map<String, dynamic> json) => _$AdminTicketOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminTicketOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/ticket_reply_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TicketOut {
  /// Returns a new [TicketOut] instance.
  TicketOut({

    required  this.id,

    required  this.text,

    required  this.status,

    required  this.replies,

    required  this.createdAt,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is TicketOut &&
      other.id == id &&
      other.text == text &&
      other.status == status &&
      other.replies == replies &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        text.hashCode +
        status.hashCode +
        replies.hashCode +
        createdAt.hashCode;

  factory TicketOut.fromJson(Map<String, dynamic> json) => _$TicketOutFromJson(json);

  Map<String, dynamic> toJson() => _$TicketOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


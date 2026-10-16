//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket_reply_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TicketReplyOut {
  /// Returns a new [TicketReplyOut] instance.
  TicketReplyOut({

    required  this.by,

    required  this.name,

    required  this.text,

    required  this.at,
  });

      /// STAFF
  @JsonKey(
    
    name: r'by',
    required: true,
    includeIfNull: false,
  )


  final String by;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TicketReplyOut &&
      other.by == by &&
      other.name == name &&
      other.text == text &&
      other.at == at;

    @override
    int get hashCode =>
        by.hashCode +
        name.hashCode +
        text.hashCode +
        at.hashCode;

  factory TicketReplyOut.fromJson(Map<String, dynamic> json) => _$TicketReplyOutFromJson(json);

  Map<String, dynamic> toJson() => _$TicketReplyOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


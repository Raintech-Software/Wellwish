//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket_reply_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TicketReplyIn {
  /// Returns a new [TicketReplyIn] instance.
  TicketReplyIn({

    required  this.text,
  });

  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TicketReplyIn &&
      other.text == text;

    @override
    int get hashCode =>
        text.hashCode;

  factory TicketReplyIn.fromJson(Map<String, dynamic> json) => _$TicketReplyInFromJson(json);

  Map<String, dynamic> toJson() => _$TicketReplyInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unread_count_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UnreadCountOut {
  /// Returns a new [UnreadCountOut] instance.
  UnreadCountOut({

    required  this.unread,
  });

  @JsonKey(
    
    name: r'unread',
    required: true,
    includeIfNull: false,
  )


  final int unread;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UnreadCountOut &&
      other.unread == unread;

    @override
    int get hashCode =>
        unread.hashCode;

  factory UnreadCountOut.fromJson(Map<String, dynamic> json) => _$UnreadCountOutFromJson(json);

  Map<String, dynamic> toJson() => _$UnreadCountOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


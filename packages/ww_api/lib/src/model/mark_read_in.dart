//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mark_read_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MarkReadIn {
  /// Returns a new [MarkReadIn] instance.
  MarkReadIn({

     this.ids,
  });

      /// Leave out to mark all read
  @JsonKey(
    
    name: r'ids',
    required: false,
    includeIfNull: false,
  )


  final List<String>? ids;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MarkReadIn &&
      other.ids == ids;

    @override
    int get hashCode =>
        (ids == null ? 0 : ids.hashCode);

  factory MarkReadIn.fromJson(Map<String, dynamic> json) => _$MarkReadInFromJson(json);

  Map<String, dynamic> toJson() => _$MarkReadInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


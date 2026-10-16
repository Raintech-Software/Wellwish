//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reorder_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReorderIn {
  /// Returns a new [ReorderIn] instance.
  ReorderIn({

    required  this.ids,
  });

  @JsonKey(
    
    name: r'ids',
    required: true,
    includeIfNull: false,
  )


  final List<String> ids;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReorderIn &&
      other.ids == ids;

    @override
    int get hashCode =>
        ids.hashCode;

  factory ReorderIn.fromJson(Map<String, dynamic> json) => _$ReorderInFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inside_area_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InsideAreaOut {
  /// Returns a new [InsideAreaOut] instance.
  InsideAreaOut({

    required  this.inside,
  });

  @JsonKey(
    
    name: r'inside',
    required: true,
    includeIfNull: false,
  )


  final bool inside;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InsideAreaOut &&
      other.inside == inside;

    @override
    int get hashCode =>
        inside.hashCode;

  factory InsideAreaOut.fromJson(Map<String, dynamic> json) => _$InsideAreaOutFromJson(json);

  Map<String, dynamic> toJson() => _$InsideAreaOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


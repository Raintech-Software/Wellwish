//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'availability_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AvailabilityIn {
  /// Returns a new [AvailabilityIn] instance.
  AvailabilityIn({

    required  this.availableToday,
  });

  @JsonKey(
    
    name: r'availableToday',
    required: true,
    includeIfNull: false,
  )


  final bool availableToday;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AvailabilityIn &&
      other.availableToday == availableToday;

    @override
    int get hashCode =>
        availableToday.hashCode;

  factory AvailabilityIn.fromJson(Map<String, dynamic> json) => _$AvailabilityInFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


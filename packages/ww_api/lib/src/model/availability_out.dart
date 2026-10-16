//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'availability_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AvailabilityOut {
  /// Returns a new [AvailabilityOut] instance.
  AvailabilityOut({

    required  this.availableToday,

     this.selfieToday = false,
  });

  @JsonKey(
    
    name: r'availableToday',
    required: true,
    includeIfNull: false,
  )


  final bool availableToday;



      /// Today's selfie is taken (needed to switch on)
  @JsonKey(
    defaultValue: false,
    name: r'selfieToday',
    required: false,
    includeIfNull: false,
  )


  final bool? selfieToday;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AvailabilityOut &&
      other.availableToday == availableToday &&
      other.selfieToday == selfieToday;

    @override
    int get hashCode =>
        availableToday.hashCode +
        selfieToday.hashCode;

  factory AvailabilityOut.fromJson(Map<String, dynamic> json) => _$AvailabilityOutFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


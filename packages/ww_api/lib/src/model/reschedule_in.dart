//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reschedule_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RescheduleIn {
  /// Returns a new [RescheduleIn] instance.
  RescheduleIn({

    required  this.pickupAt,

     this.appointmentAt,
  });

  @JsonKey(
    
    name: r'pickupAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime pickupAt;



  @JsonKey(
    
    name: r'appointmentAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? appointmentAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RescheduleIn &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt;

    @override
    int get hashCode =>
        pickupAt.hashCode +
        (appointmentAt == null ? 0 : appointmentAt.hashCode);

  factory RescheduleIn.fromJson(Map<String, dynamic> json) => _$RescheduleInFromJson(json);

  Map<String, dynamic> toJson() => _$RescheduleInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_booking_patient_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminBookingPatientOut {
  /// Returns a new [AdminBookingPatientOut] instance.
  AdminBookingPatientOut({

    required  this.id,

    required  this.fullName,

    required  this.phone,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminBookingPatientOut &&
      other.id == id &&
      other.fullName == fullName &&
      other.phone == phone;

    @override
    int get hashCode =>
        id.hashCode +
        fullName.hashCode +
        phone.hashCode;

  factory AdminBookingPatientOut.fromJson(Map<String, dynamic> json) => _$AdminBookingPatientOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminBookingPatientOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


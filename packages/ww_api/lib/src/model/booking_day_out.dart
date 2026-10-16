//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_day_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingDayOut {
  /// Returns a new [BookingDayOut] instance.
  BookingDayOut({

    required  this.date,

    required  this.available,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final DateTime date;



      /// False: blocked, full or no time left (greyed out)
  @JsonKey(
    
    name: r'available',
    required: true,
    includeIfNull: false,
  )


  final bool available;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingDayOut &&
      other.date == date &&
      other.available == available;

    @override
    int get hashCode =>
        date.hashCode +
        available.hashCode;

  factory BookingDayOut.fromJson(Map<String, dynamic> json) => _$BookingDayOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDayOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


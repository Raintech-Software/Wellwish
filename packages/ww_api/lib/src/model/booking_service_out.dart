//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_service_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingServiceOut {
  /// Returns a new [BookingServiceOut] instance.
  BookingServiceOut({

    required  this.name,

    required  this.nameHi,

    required  this.nameOr,

    required  this.partnerType,

    required  this.visitType,

    required  this.durationMin,

    required  this.docsRequired,

    required  this.pricePaise,

    required  this.bookingFeePaise,

    required  this.balancePaise,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'nameHi',
    required: true,
    includeIfNull: false,
  )


  final String nameHi;



  @JsonKey(
    
    name: r'nameOr',
    required: true,
    includeIfNull: false,
  )


  final String nameOr;



  @JsonKey(
    
    name: r'partnerType',
    required: true,
    includeIfNull: false,
  )


  final String partnerType;



  @JsonKey(
    
    name: r'visitType',
    required: true,
    includeIfNull: false,
  )


  final String visitType;



  @JsonKey(
    
    name: r'durationMin',
    required: true,
    includeIfNull: false,
  )


  final int durationMin;



  @JsonKey(
    
    name: r'docsRequired',
    required: true,
    includeIfNull: false,
  )


  final bool docsRequired;



  @JsonKey(
    
    name: r'pricePaise',
    required: true,
    includeIfNull: false,
  )


  final int pricePaise;



      /// Paid online
  @JsonKey(
    
    name: r'bookingFeePaise',
    required: true,
    includeIfNull: false,
  )


  final int bookingFeePaise;



      /// Paid to the partner after the visit
  @JsonKey(
    
    name: r'balancePaise',
    required: true,
    includeIfNull: false,
  )


  final int balancePaise;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingServiceOut &&
      other.name == name &&
      other.nameHi == nameHi &&
      other.nameOr == nameOr &&
      other.partnerType == partnerType &&
      other.visitType == visitType &&
      other.durationMin == durationMin &&
      other.docsRequired == docsRequired &&
      other.pricePaise == pricePaise &&
      other.bookingFeePaise == bookingFeePaise &&
      other.balancePaise == balancePaise;

    @override
    int get hashCode =>
        name.hashCode +
        nameHi.hashCode +
        nameOr.hashCode +
        partnerType.hashCode +
        visitType.hashCode +
        durationMin.hashCode +
        docsRequired.hashCode +
        pricePaise.hashCode +
        bookingFeePaise.hashCode +
        balancePaise.hashCode;

  factory BookingServiceOut.fromJson(Map<String, dynamic> json) => _$BookingServiceOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingServiceOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


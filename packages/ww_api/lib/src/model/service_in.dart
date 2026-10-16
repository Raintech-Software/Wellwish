//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ServiceIn {
  /// Returns a new [ServiceIn] instance.
  ServiceIn({

    required  this.name,

     this.nameHi = '',

     this.nameOr = '',

     this.description = '',

     this.descriptionHi = '',

     this.descriptionOr = '',

    required  this.partnerType,

    required  this.visitType,

    required  this.pricePaise,

    required  this.bookingFeePaise,

    required  this.durationMin,

     this.docsRequired = false,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    defaultValue: '',
    name: r'nameHi',
    required: false,
    includeIfNull: false,
  )


  final String? nameHi;



  @JsonKey(
    defaultValue: '',
    name: r'nameOr',
    required: false,
    includeIfNull: false,
  )


  final String? nameOr;



  @JsonKey(
    defaultValue: '',
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    defaultValue: '',
    name: r'descriptionHi',
    required: false,
    includeIfNull: false,
  )


  final String? descriptionHi;



  @JsonKey(
    defaultValue: '',
    name: r'descriptionOr',
    required: false,
    includeIfNull: false,
  )


  final String? descriptionOr;



  @JsonKey(
    
    name: r'partnerType',
    required: true,
    includeIfNull: false,
  )


  final ServiceInPartnerTypeEnum partnerType;



  @JsonKey(
    
    name: r'visitType',
    required: true,
    includeIfNull: false,
  )


  final ServiceInVisitTypeEnum visitType;



      /// ₹1 = 100 paise
          // minimum: 0
          // maximum: 10000000
  @JsonKey(
    
    name: r'pricePaise',
    required: true,
    includeIfNull: false,
  )


  final int pricePaise;



      /// At least ₹1 (Razorpay's minimum)
          // minimum: 100
  @JsonKey(
    
    name: r'bookingFeePaise',
    required: true,
    includeIfNull: false,
  )


  final int bookingFeePaise;



          // minimum: 15
          // maximum: 1440
  @JsonKey(
    
    name: r'durationMin',
    required: true,
    includeIfNull: false,
  )


  final int durationMin;



  @JsonKey(
    defaultValue: false,
    name: r'docsRequired',
    required: false,
    includeIfNull: false,
  )


  final bool? docsRequired;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ServiceIn &&
      other.name == name &&
      other.nameHi == nameHi &&
      other.nameOr == nameOr &&
      other.description == description &&
      other.descriptionHi == descriptionHi &&
      other.descriptionOr == descriptionOr &&
      other.partnerType == partnerType &&
      other.visitType == visitType &&
      other.pricePaise == pricePaise &&
      other.bookingFeePaise == bookingFeePaise &&
      other.durationMin == durationMin &&
      other.docsRequired == docsRequired;

    @override
    int get hashCode =>
        name.hashCode +
        nameHi.hashCode +
        nameOr.hashCode +
        description.hashCode +
        descriptionHi.hashCode +
        descriptionOr.hashCode +
        partnerType.hashCode +
        visitType.hashCode +
        pricePaise.hashCode +
        bookingFeePaise.hashCode +
        durationMin.hashCode +
        docsRequired.hashCode;

  factory ServiceIn.fromJson(Map<String, dynamic> json) => _$ServiceInFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ServiceInPartnerTypeEnum {
@JsonValue(r'COMPANION')
COMPANION(r'COMPANION'),
@JsonValue(r'NURSE')
NURSE(r'NURSE');

const ServiceInPartnerTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum ServiceInVisitTypeEnum {
@JsonValue(r'HOSPITAL_VISIT')
HOSPITAL_VISIT(r'HOSPITAL_VISIT'),
@JsonValue(r'HOME_VISIT')
HOME_VISIT(r'HOME_VISIT'),
@JsonValue(r'ERRAND')
ERRAND(r'ERRAND');

const ServiceInVisitTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ServiceOut {
  /// Returns a new [ServiceOut] instance.
  ServiceOut({

    required  this.id,

    required  this.name,

    required  this.nameHi,

    required  this.nameOr,

    required  this.description,

    required  this.descriptionHi,

    required  this.descriptionOr,

    required  this.partnerType,

    required  this.visitType,

    required  this.pricePaise,

    required  this.bookingFeePaise,

    required  this.balancePaise,

    required  this.durationMin,

    required  this.docsRequired,

    required  this.isActive,

    required  this.sort,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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
    
    name: r'description',
    required: true,
    includeIfNull: false,
  )


  final String description;



  @JsonKey(
    
    name: r'descriptionHi',
    required: true,
    includeIfNull: false,
  )


  final String descriptionHi;



  @JsonKey(
    
    name: r'descriptionOr',
    required: true,
    includeIfNull: false,
  )


  final String descriptionOr;



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
    
    name: r'pricePaise',
    required: true,
    includeIfNull: false,
  )


  final int pricePaise;



  @JsonKey(
    
    name: r'bookingFeePaise',
    required: true,
    includeIfNull: false,
  )


  final int bookingFeePaise;



      /// price minus booking fee, paid to the partner
  @JsonKey(
    
    name: r'balancePaise',
    required: true,
    includeIfNull: false,
  )


  final int balancePaise;



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
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;



  @JsonKey(
    
    name: r'sort',
    required: true,
    includeIfNull: false,
  )


  final int sort;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ServiceOut &&
      other.id == id &&
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
      other.balancePaise == balancePaise &&
      other.durationMin == durationMin &&
      other.docsRequired == docsRequired &&
      other.isActive == isActive &&
      other.sort == sort;

    @override
    int get hashCode =>
        id.hashCode +
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
        balancePaise.hashCode +
        durationMin.hashCode +
        docsRequired.hashCode +
        isActive.hashCode +
        sort.hashCode;

  factory ServiceOut.fromJson(Map<String, dynamic> json) => _$ServiceOutFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


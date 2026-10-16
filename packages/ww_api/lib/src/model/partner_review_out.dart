//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_review_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerReviewOut {
  /// Returns a new [PartnerReviewOut] instance.
  PartnerReviewOut({

    required  this.stars,

    required  this.tags,

    required  this.comment,

    required  this.createdAt,

    required  this.serviceName,

     this.serviceNameHi = '',

     this.serviceNameOr = '',
  });

  @JsonKey(
    
    name: r'stars',
    required: true,
    includeIfNull: false,
  )


  final int stars;



  @JsonKey(
    
    name: r'tags',
    required: true,
    includeIfNull: false,
  )


  final List<String> tags;



  @JsonKey(
    
    name: r'comment',
    required: true,
    includeIfNull: false,
  )


  final String comment;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'serviceName',
    required: true,
    includeIfNull: false,
  )


  final String serviceName;



      /// The service in Hindi, when it has one (9.1)
  @JsonKey(
    defaultValue: '',
    name: r'serviceNameHi',
    required: false,
    includeIfNull: false,
  )


  final String? serviceNameHi;



      /// The service in Odia, when it has one (9.1)
  @JsonKey(
    defaultValue: '',
    name: r'serviceNameOr',
    required: false,
    includeIfNull: false,
  )


  final String? serviceNameOr;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerReviewOut &&
      other.stars == stars &&
      other.tags == tags &&
      other.comment == comment &&
      other.createdAt == createdAt &&
      other.serviceName == serviceName &&
      other.serviceNameHi == serviceNameHi &&
      other.serviceNameOr == serviceNameOr;

    @override
    int get hashCode =>
        stars.hashCode +
        tags.hashCode +
        comment.hashCode +
        createdAt.hashCode +
        serviceName.hashCode +
        serviceNameHi.hashCode +
        serviceNameOr.hashCode;

  factory PartnerReviewOut.fromJson(Map<String, dynamic> json) => _$PartnerReviewOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerReviewOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


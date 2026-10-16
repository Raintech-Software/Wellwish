//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_review_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminReviewOut {
  /// Returns a new [AdminReviewOut] instance.
  AdminReviewOut({

    required  this.stars,

    required  this.tags,

    required  this.comment,

    required  this.createdAt,

    required  this.id,

    required  this.bookingId,

    required  this.code,

    required  this.partnerId,

    required  this.partnerName,

    required  this.status,

    required  this.hiddenReason,
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
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'bookingId',
    required: true,
    includeIfNull: false,
  )


  final String bookingId;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'partnerId',
    required: true,
    includeIfNull: false,
  )


  final String partnerId;



  @JsonKey(
    
    name: r'partnerName',
    required: true,
    includeIfNull: false,
  )


  final String partnerName;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'hiddenReason',
    required: true,
    includeIfNull: false,
  )


  final String hiddenReason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminReviewOut &&
      other.stars == stars &&
      other.tags == tags &&
      other.comment == comment &&
      other.createdAt == createdAt &&
      other.id == id &&
      other.bookingId == bookingId &&
      other.code == code &&
      other.partnerId == partnerId &&
      other.partnerName == partnerName &&
      other.status == status &&
      other.hiddenReason == hiddenReason;

    @override
    int get hashCode =>
        stars.hashCode +
        tags.hashCode +
        comment.hashCode +
        createdAt.hashCode +
        id.hashCode +
        bookingId.hashCode +
        code.hashCode +
        partnerId.hashCode +
        partnerName.hashCode +
        status.hashCode +
        hiddenReason.hashCode;

  factory AdminReviewOut.fromJson(Map<String, dynamic> json) => _$AdminReviewOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminReviewOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


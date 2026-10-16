//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReviewOut {
  /// Returns a new [ReviewOut] instance.
  ReviewOut({

    required  this.stars,

    required  this.tags,

    required  this.comment,

    required  this.createdAt,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReviewOut &&
      other.stars == stars &&
      other.tags == tags &&
      other.comment == comment &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        stars.hashCode +
        tags.hashCode +
        comment.hashCode +
        createdAt.hashCode;

  factory ReviewOut.fromJson(Map<String, dynamic> json) => _$ReviewOutFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


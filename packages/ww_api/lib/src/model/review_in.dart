//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReviewIn {
  /// Returns a new [ReviewIn] instance.
  ReviewIn({

    required  this.stars,

     this.tags,

     this.comment = '',
  });

          // minimum: 1
          // maximum: 5
  @JsonKey(
    
    name: r'stars',
    required: true,
    includeIfNull: false,
  )


  final int stars;



  @JsonKey(
    
    name: r'tags',
    required: false,
    includeIfNull: false,
  )


  final List<ReviewInTagsEnum>? tags;



  @JsonKey(
    defaultValue: '',
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReviewIn &&
      other.stars == stars &&
      other.tags == tags &&
      other.comment == comment;

    @override
    int get hashCode =>
        stars.hashCode +
        tags.hashCode +
        comment.hashCode;

  factory ReviewIn.fromJson(Map<String, dynamic> json) => _$ReviewInFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ReviewInTagsEnum {
@JsonValue(r'ON_TIME')
ON_TIME(r'ON_TIME'),
@JsonValue(r'KIND')
KIND(r'KIND'),
@JsonValue(r'HELPFUL')
HELPFUL(r'HELPFUL'),
@JsonValue(r'PROFESSIONAL')
PROFESSIONAL(r'PROFESSIONAL'),
@JsonValue(r'GOOD_COMMUNICATION')
GOOD_COMMUNICATION(r'GOOD_COMMUNICATION'),
@JsonValue(r'LATE')
LATE(r'LATE'),
@JsonValue(r'RUDE')
RUDE(r'RUDE'),
@JsonValue(r'UNHELPFUL')
UNHELPFUL(r'UNHELPFUL');

const ReviewInTagsEnum(this.value);

final String value;

@override
String toString() => value;
}



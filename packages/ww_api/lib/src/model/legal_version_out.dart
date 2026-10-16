//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_version_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalVersionOut {
  /// Returns a new [LegalVersionOut] instance.
  LegalVersionOut({

    required  this.version,

    required  this.askedAgain,

    required  this.publishedAt,

    required  this.publishedBy,
  });

  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final int version;



  @JsonKey(
    
    name: r'askedAgain',
    required: true,
    includeIfNull: false,
  )


  final bool askedAgain;



  @JsonKey(
    
    name: r'publishedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime publishedAt;



  @JsonKey(
    
    name: r'publishedBy',
    required: true,
    includeIfNull: true,
  )


  final String? publishedBy;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalVersionOut &&
      other.version == version &&
      other.askedAgain == askedAgain &&
      other.publishedAt == publishedAt &&
      other.publishedBy == publishedBy;

    @override
    int get hashCode =>
        version.hashCode +
        askedAgain.hashCode +
        publishedAt.hashCode +
        (publishedBy == null ? 0 : publishedBy.hashCode);

  factory LegalVersionOut.fromJson(Map<String, dynamic> json) => _$LegalVersionOutFromJson(json);

  Map<String, dynamic> toJson() => _$LegalVersionOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


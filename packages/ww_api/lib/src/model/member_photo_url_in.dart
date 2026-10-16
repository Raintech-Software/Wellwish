//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_photo_url_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MemberPhotoUrlIn {
  /// Returns a new [MemberPhotoUrlIn] instance.
  MemberPhotoUrlIn({

    required  this.mime,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'mime',
    required: true,
    includeIfNull: false,
  )


  final String mime;



          // minimum: 0
  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final int sizeBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MemberPhotoUrlIn &&
      other.mime == mime &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        mime.hashCode +
        sizeBytes.hashCode;

  factory MemberPhotoUrlIn.fromJson(Map<String, dynamic> json) => _$MemberPhotoUrlInFromJson(json);

  Map<String, dynamic> toJson() => _$MemberPhotoUrlInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


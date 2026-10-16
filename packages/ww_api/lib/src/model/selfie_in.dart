//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'selfie_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SelfieIn {
  /// Returns a new [SelfieIn] instance.
  SelfieIn({

    required  this.fileKey,
  });

      /// From the partner_selfie upload URL
  @JsonKey(
    
    name: r'fileKey',
    required: true,
    includeIfNull: false,
  )


  final String fileKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SelfieIn &&
      other.fileKey == fileKey;

    @override
    int get hashCode =>
        fileKey.hashCode;

  factory SelfieIn.fromJson(Map<String, dynamic> json) => _$SelfieInFromJson(json);

  Map<String, dynamic> toJson() => _$SelfieInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


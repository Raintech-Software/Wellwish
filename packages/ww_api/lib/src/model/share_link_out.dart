//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'share_link_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ShareLinkOut {
  /// Returns a new [ShareLinkOut] instance.
  ShareLinkOut({

    required  this.url,

    required  this.expiresAt,
  });

  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ShareLinkOut &&
      other.url == url &&
      other.expiresAt == expiresAt;

    @override
    int get hashCode =>
        url.hashCode +
        expiresAt.hashCode;

  factory ShareLinkOut.fromJson(Map<String, dynamic> json) => _$ShareLinkOutFromJson(json);

  Map<String, dynamic> toJson() => _$ShareLinkOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


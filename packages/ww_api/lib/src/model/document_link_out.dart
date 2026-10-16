//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_link_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentLinkOut {
  /// Returns a new [DocumentLinkOut] instance.
  DocumentLinkOut({

    required  this.url,

    required  this.mime,
  });

  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;



  @JsonKey(
    
    name: r'mime',
    required: true,
    includeIfNull: false,
  )


  final String mime;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DocumentLinkOut &&
      other.url == url &&
      other.mime == mime;

    @override
    int get hashCode =>
        url.hashCode +
        mime.hashCode;

  factory DocumentLinkOut.fromJson(Map<String, dynamic> json) => _$DocumentLinkOutFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentLinkOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


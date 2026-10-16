//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'view_url_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ViewUrlOut {
  /// Returns a new [ViewUrlOut] instance.
  ViewUrlOut({

    required  this.url,

    required  this.mime,
  });

      /// Works for 5 minutes
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
    bool operator ==(Object other) => identical(this, other) || other is ViewUrlOut &&
      other.url == url &&
      other.mime == mime;

    @override
    int get hashCode =>
        url.hashCode +
        mime.hashCode;

  factory ViewUrlOut.fromJson(Map<String, dynamic> json) => _$ViewUrlOutFromJson(json);

  Map<String, dynamic> toJson() => _$ViewUrlOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/token_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoogleOut {
  /// Returns a new [GoogleOut] instance.
  GoogleOut({

    required  this.status,

     this.tokens,

     this.googleLinkToken,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final GoogleOutStatusEnum status;



  @JsonKey(
    
    name: r'tokens',
    required: false,
    includeIfNull: false,
  )


  final TokenOut? tokens;



  @JsonKey(
    
    name: r'googleLinkToken',
    required: false,
    includeIfNull: false,
  )


  final String? googleLinkToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoogleOut &&
      other.status == status &&
      other.tokens == tokens &&
      other.googleLinkToken == googleLinkToken;

    @override
    int get hashCode =>
        status.hashCode +
        (tokens == null ? 0 : tokens.hashCode) +
        (googleLinkToken == null ? 0 : googleLinkToken.hashCode);

  factory GoogleOut.fromJson(Map<String, dynamic> json) => _$GoogleOutFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum GoogleOutStatusEnum {
@JsonValue(r'LOGGED_IN')
LOGGED_IN(r'LOGGED_IN'),
@JsonValue(r'PHONE_REQUIRED')
PHONE_REQUIRED(r'PHONE_REQUIRED');

const GoogleOutStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TokenOut {
  /// Returns a new [TokenOut] instance.
  TokenOut({

    required  this.accessToken,

    required  this.refreshToken,

    required  this.expiresIn,

     this.tokenType = 'Bearer',

     this.isNewUser = false,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



  @JsonKey(
    
    name: r'refreshToken',
    required: true,
    includeIfNull: false,
  )


  final String refreshToken;



      /// Seconds until the access token expires
  @JsonKey(
    
    name: r'expiresIn',
    required: true,
    includeIfNull: false,
  )


  final int expiresIn;



  @JsonKey(
    defaultValue: 'Bearer',
    name: r'tokenType',
    required: false,
    includeIfNull: false,
  )


  final String? tokenType;



  @JsonKey(
    defaultValue: false,
    name: r'isNewUser',
    required: false,
    includeIfNull: false,
  )


  final bool? isNewUser;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TokenOut &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.expiresIn == expiresIn &&
      other.tokenType == tokenType &&
      other.isNewUser == isNewUser;

    @override
    int get hashCode =>
        accessToken.hashCode +
        refreshToken.hashCode +
        expiresIn.hashCode +
        tokenType.hashCode +
        isNewUser.hashCode;

  factory TokenOut.fromJson(Map<String, dynamic> json) => _$TokenOutFromJson(json);

  Map<String, dynamic> toJson() => _$TokenOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


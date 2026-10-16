//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/staff_me_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_token_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffTokenOut {
  /// Returns a new [StaffTokenOut] instance.
  StaffTokenOut({

    required  this.accessToken,

    required  this.expiresIn,

    required  this.staff,

     this.recoveryCodes,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



  @JsonKey(
    
    name: r'expiresIn',
    required: true,
    includeIfNull: false,
  )


  final int expiresIn;



  @JsonKey(
    
    name: r'staff',
    required: true,
    includeIfNull: false,
  )


  final StaffMeOut staff;



      /// Only right after 2FA was set up: show once, then never again
  @JsonKey(
    
    name: r'recoveryCodes',
    required: false,
    includeIfNull: false,
  )


  final List<String>? recoveryCodes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffTokenOut &&
      other.accessToken == accessToken &&
      other.expiresIn == expiresIn &&
      other.staff == staff &&
      other.recoveryCodes == recoveryCodes;

    @override
    int get hashCode =>
        accessToken.hashCode +
        expiresIn.hashCode +
        staff.hashCode +
        (recoveryCodes == null ? 0 : recoveryCodes.hashCode);

  factory StaffTokenOut.fromJson(Map<String, dynamic> json) => _$StaffTokenOutFromJson(json);

  Map<String, dynamic> toJson() => _$StaffTokenOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


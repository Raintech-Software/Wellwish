//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PhoneOut {
  /// Returns a new [PhoneOut] instance.
  PhoneOut({

    required  this.kind,

    required  this.phone,

    required  this.verified,
  });

  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final String kind;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'verified',
    required: true,
    includeIfNull: false,
  )


  final bool verified;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PhoneOut &&
      other.kind == kind &&
      other.phone == phone &&
      other.verified == verified;

    @override
    int get hashCode =>
        kind.hashCode +
        phone.hashCode +
        verified.hashCode;

  factory PhoneOut.fromJson(Map<String, dynamic> json) => _$PhoneOutFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


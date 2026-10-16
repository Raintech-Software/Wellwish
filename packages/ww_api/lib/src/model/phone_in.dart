//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PhoneIn {
  /// Returns a new [PhoneIn] instance.
  PhoneIn({

    required  this.phone,
  });

      /// Indian mobile, e.g. 9876543210
  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PhoneIn &&
      other.phone == phone;

    @override
    int get hashCode =>
        phone.hashCode;

  factory PhoneIn.fromJson(Map<String, dynamic> json) => _$PhoneInFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


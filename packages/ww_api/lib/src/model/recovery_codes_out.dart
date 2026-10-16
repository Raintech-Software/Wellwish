//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recovery_codes_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecoveryCodesOut {
  /// Returns a new [RecoveryCodesOut] instance.
  RecoveryCodesOut({

    required  this.codes,
  });

      /// Shown once: 10 one-time codes
  @JsonKey(
    
    name: r'codes',
    required: true,
    includeIfNull: false,
  )


  final List<String> codes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecoveryCodesOut &&
      other.codes == codes;

    @override
    int get hashCode =>
        codes.hashCode;

  factory RecoveryCodesOut.fromJson(Map<String, dynamic> json) => _$RecoveryCodesOutFromJson(json);

  Map<String, dynamic> toJson() => _$RecoveryCodesOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


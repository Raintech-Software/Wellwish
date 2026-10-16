//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ok_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OkOut {
  /// Returns a new [OkOut] instance.
  OkOut({

     this.ok = true,
  });

  @JsonKey(
    defaultValue: true,
    name: r'ok',
    required: false,
    includeIfNull: false,
  )


  final bool? ok;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OkOut &&
      other.ok == ok;

    @override
    int get hashCode =>
        ok.hashCode;

  factory OkOut.fromJson(Map<String, dynamic> json) => _$OkOutFromJson(json);

  Map<String, dynamic> toJson() => _$OkOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


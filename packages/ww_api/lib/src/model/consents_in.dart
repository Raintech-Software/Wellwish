//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/consent_item_in.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consents_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConsentsIn {
  /// Returns a new [ConsentsIn] instance.
  ConsentsIn({

    required  this.items,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<ConsentItemIn> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConsentsIn &&
      other.items == items;

    @override
    int get hashCode =>
        items.hashCode;

  factory ConsentsIn.fromJson(Map<String, dynamic> json) => _$ConsentsInFromJson(json);

  Map<String, dynamic> toJson() => _$ConsentsInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


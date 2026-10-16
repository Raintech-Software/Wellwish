//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sos_resolve_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SosResolveIn {
  /// Returns a new [SosResolveIn] instance.
  SosResolveIn({

    required  this.notes,
  });

  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: false,
  )


  final String notes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SosResolveIn &&
      other.notes == notes;

    @override
    int get hashCode =>
        notes.hashCode;

  factory SosResolveIn.fromJson(Map<String, dynamic> json) => _$SosResolveInFromJson(json);

  Map<String, dynamic> toJson() => _$SosResolveInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


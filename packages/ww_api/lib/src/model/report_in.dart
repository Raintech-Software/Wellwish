//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReportIn {
  /// Returns a new [ReportIn] instance.
  ReportIn({

    required  this.text,
  });

  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReportIn &&
      other.text == text;

    @override
    int get hashCode =>
        text.hashCode;

  factory ReportIn.fromJson(Map<String, dynamic> json) => _$ReportInFromJson(json);

  Map<String, dynamic> toJson() => _$ReportInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


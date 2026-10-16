//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'input.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Input {
  /// Returns a new [Input] instance.
  Input({

     this.page = 1,

     this.pageSize = 20,
  });

          // minimum: 1
  @JsonKey(
    defaultValue: 1,
    name: r'page',
    required: false,
    includeIfNull: false,
  )


  final int? page;



          // minimum: 1
          // maximum: 100
  @JsonKey(
    defaultValue: 20,
    name: r'pageSize',
    required: false,
    includeIfNull: false,
  )


  final int? pageSize;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Input &&
      other.page == page &&
      other.pageSize == pageSize;

    @override
    int get hashCode =>
        page.hashCode +
        pageSize.hashCode;

  factory Input.fromJson(Map<String, dynamic> json) => _$InputFromJson(json);

  Map<String, dynamic> toJson() => _$InputToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


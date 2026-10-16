//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_filter.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddressFilter {
  /// Returns a new [AddressFilter] instance.
  AddressFilter({

     this.memberId,
  });

  @JsonKey(
    
    name: r'memberId',
    required: false,
    includeIfNull: false,
  )


  final String? memberId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddressFilter &&
      other.memberId == memberId;

    @override
    int get hashCode =>
        (memberId == null ? 0 : memberId.hashCode);

  factory AddressFilter.fromJson(Map<String, dynamic> json) => _$AddressFilterFromJson(json);

  Map<String, dynamic> toJson() => _$AddressFilterToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


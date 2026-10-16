//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blocked_time_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BlockedTimeIn {
  /// Returns a new [BlockedTimeIn] instance.
  BlockedTimeIn({

    required  this.fromTs,

    required  this.toTs,

    required  this.reason,

     this.serviceType,
  });

  @JsonKey(
    
    name: r'fromTs',
    required: true,
    includeIfNull: false,
  )


  final DateTime fromTs;



  @JsonKey(
    
    name: r'toTs',
    required: true,
    includeIfNull: false,
  )


  final DateTime toTs;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



      /// Empty = all services
  @JsonKey(
    
    name: r'serviceType',
    required: false,
    includeIfNull: false,
  )


  final BlockedTimeInServiceTypeEnum? serviceType;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BlockedTimeIn &&
      other.fromTs == fromTs &&
      other.toTs == toTs &&
      other.reason == reason &&
      other.serviceType == serviceType;

    @override
    int get hashCode =>
        fromTs.hashCode +
        toTs.hashCode +
        reason.hashCode +
        (serviceType == null ? 0 : serviceType.hashCode);

  factory BlockedTimeIn.fromJson(Map<String, dynamic> json) => _$BlockedTimeInFromJson(json);

  Map<String, dynamic> toJson() => _$BlockedTimeInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Empty = all services
enum BlockedTimeInServiceTypeEnum {
@JsonValue(r'COMPANION')
COMPANION(r'COMPANION'),
@JsonValue(r'NURSE')
NURSE(r'NURSE');

const BlockedTimeInServiceTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



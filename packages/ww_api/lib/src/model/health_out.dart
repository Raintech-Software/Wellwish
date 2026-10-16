//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HealthOut {
  /// Returns a new [HealthOut] instance.
  HealthOut({

    required  this.status,

    required  this.db,

    required  this.redis,

    required  this.env,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'db',
    required: true,
    includeIfNull: false,
  )


  final String db;



  @JsonKey(
    
    name: r'redis',
    required: true,
    includeIfNull: false,
  )


  final String redis;



  @JsonKey(
    
    name: r'env',
    required: true,
    includeIfNull: false,
  )


  final String env;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HealthOut &&
      other.status == status &&
      other.db == db &&
      other.redis == redis &&
      other.env == env;

    @override
    int get hashCode =>
        status.hashCode +
        db.hashCode +
        redis.hashCode +
        env.hashCode;

  factory HealthOut.fromJson(Map<String, dynamic> json) => _$HealthOutFromJson(json);

  Map<String, dynamic> toJson() => _$HealthOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


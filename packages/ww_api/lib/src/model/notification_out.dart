//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NotificationOut {
  /// Returns a new [NotificationOut] instance.
  NotificationOut({

    required  this.id,

    required  this.type,

    required  this.title,

    required  this.body,

    required  this.data,

    required  this.createdAt,

    required  this.readAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final Map<String, String> data;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'readAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? readAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is NotificationOut &&
      other.id == id &&
      other.type == type &&
      other.title == title &&
      other.body == body &&
      other.data == data &&
      other.createdAt == createdAt &&
      other.readAt == readAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        title.hashCode +
        body.hashCode +
        data.hashCode +
        createdAt.hashCode +
        (readAt == null ? 0 : readAt.hashCode);

  factory NotificationOut.fromJson(Map<String, dynamic> json) => _$NotificationOutFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


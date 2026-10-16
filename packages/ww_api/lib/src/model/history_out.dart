//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HistoryOut {
  /// Returns a new [HistoryOut] instance.
  HistoryOut({

    required  this.at,

    required  this.action,

     this.by,

    required  this.before,

    required  this.after,

    required  this.reason,
  });

  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false,
  )


  final String action;



      /// Staff name; empty = the partner or the system
  @JsonKey(
    
    name: r'by',
    required: false,
    includeIfNull: false,
  )


  final String? by;



  @JsonKey(
    
    name: r'before',
    required: true,
    includeIfNull: true,
  )


  final String? before;



  @JsonKey(
    
    name: r'after',
    required: true,
    includeIfNull: true,
  )


  final String? after;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HistoryOut &&
      other.at == at &&
      other.action == action &&
      other.by == by &&
      other.before == before &&
      other.after == after &&
      other.reason == reason;

    @override
    int get hashCode =>
        at.hashCode +
        action.hashCode +
        (by == null ? 0 : by.hashCode) +
        (before == null ? 0 : before.hashCode) +
        (after == null ? 0 : after.hashCode) +
        reason.hashCode;

  factory HistoryOut.fromJson(Map<String, dynamic> json) => _$HistoryOutFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


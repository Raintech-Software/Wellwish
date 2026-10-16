//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'today_bookings_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TodayBookingsOut {
  /// Returns a new [TodayBookingsOut] instance.
  TodayBookingsOut({

    required  this.new_,

    required  this.offered,

    required  this.accepted,

    required  this.inProgress,

    required  this.completed,

    required  this.noShow,

    required  this.cancelled,

    required  this.queueToday,

    required  this.queueLater,

    required  this.queueLate,
  });

      /// Not assigned yet
  @JsonKey(
    
    name: r'new',
    required: true,
    includeIfNull: false,
  )


  final int new_;



      /// Offered, waiting for the partner's answer
  @JsonKey(
    
    name: r'offered',
    required: true,
    includeIfNull: false,
  )


  final int offered;



  @JsonKey(
    
    name: r'accepted',
    required: true,
    includeIfNull: false,
  )


  final int accepted;



  @JsonKey(
    
    name: r'inProgress',
    required: true,
    includeIfNull: false,
  )


  final int inProgress;



  @JsonKey(
    
    name: r'completed',
    required: true,
    includeIfNull: false,
  )


  final int completed;



      /// Patient not available
  @JsonKey(
    
    name: r'noShow',
    required: true,
    includeIfNull: false,
  )


  final int noShow;



  @JsonKey(
    
    name: r'cancelled',
    required: true,
    includeIfNull: false,
  )


  final int cancelled;



      /// Unassigned queue: today (incl. late ones)
  @JsonKey(
    
    name: r'queueToday',
    required: true,
    includeIfNull: false,
  )


  final int queueToday;



      /// Unassigned queue: tomorrow and later
  @JsonKey(
    
    name: r'queueLater',
    required: true,
    includeIfNull: false,
  )


  final int queueLater;



      /// In the queue past their assign deadline
  @JsonKey(
    
    name: r'queueLate',
    required: true,
    includeIfNull: false,
  )


  final int queueLate;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TodayBookingsOut &&
      other.new_ == new_ &&
      other.offered == offered &&
      other.accepted == accepted &&
      other.inProgress == inProgress &&
      other.completed == completed &&
      other.noShow == noShow &&
      other.cancelled == cancelled &&
      other.queueToday == queueToday &&
      other.queueLater == queueLater &&
      other.queueLate == queueLate;

    @override
    int get hashCode =>
        new_.hashCode +
        offered.hashCode +
        accepted.hashCode +
        inProgress.hashCode +
        completed.hashCode +
        noShow.hashCode +
        cancelled.hashCode +
        queueToday.hashCode +
        queueLater.hashCode +
        queueLate.hashCode;

  factory TodayBookingsOut.fromJson(Map<String, dynamic> json) => _$TodayBookingsOutFromJson(json);

  Map<String, dynamic> toJson() => _$TodayBookingsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


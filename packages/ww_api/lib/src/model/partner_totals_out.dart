//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_totals_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerTotalsOut {
  /// Returns a new [PartnerTotalsOut] instance.
  PartnerTotalsOut({

    required  this.today,

    required  this.thisWeek,

    required  this.upcoming,
  });

  @JsonKey(
    
    name: r'today',
    required: true,
    includeIfNull: false,
  )


  final int today;



  @JsonKey(
    
    name: r'thisWeek',
    required: true,
    includeIfNull: false,
  )


  final int thisWeek;



  @JsonKey(
    
    name: r'upcoming',
    required: true,
    includeIfNull: false,
  )


  final int upcoming;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerTotalsOut &&
      other.today == today &&
      other.thisWeek == thisWeek &&
      other.upcoming == upcoming;

    @override
    int get hashCode =>
        today.hashCode +
        thisWeek.hashCode +
        upcoming.hashCode;

  factory PartnerTotalsOut.fromJson(Map<String, dynamic> json) => _$PartnerTotalsOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerTotalsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApplicationOut {
  /// Returns a new [ApplicationOut] instance.
  ApplicationOut({

    required  this.id,

    required  this.status,

    required  this.submittedAt,

    required  this.firstSubmittedAt,

    required  this.notes,

    required  this.claimedBy,

    required  this.claimedUntil,

    required  this.decidedBy,

    required  this.decidedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'submittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime submittedAt;



  @JsonKey(
    
    name: r'firstSubmittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime firstSubmittedAt;



      /// Message to the partner (changes needed / rejected)
  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: false,
  )


  final String notes;



  @JsonKey(
    
    name: r'claimedBy',
    required: true,
    includeIfNull: true,
  )


  final String? claimedBy;



  @JsonKey(
    
    name: r'claimedUntil',
    required: true,
    includeIfNull: true,
  )


  final DateTime? claimedUntil;



  @JsonKey(
    
    name: r'decidedBy',
    required: true,
    includeIfNull: true,
  )


  final String? decidedBy;



  @JsonKey(
    
    name: r'decidedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? decidedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApplicationOut &&
      other.id == id &&
      other.status == status &&
      other.submittedAt == submittedAt &&
      other.firstSubmittedAt == firstSubmittedAt &&
      other.notes == notes &&
      other.claimedBy == claimedBy &&
      other.claimedUntil == claimedUntil &&
      other.decidedBy == decidedBy &&
      other.decidedAt == decidedAt;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        submittedAt.hashCode +
        firstSubmittedAt.hashCode +
        notes.hashCode +
        (claimedBy == null ? 0 : claimedBy.hashCode) +
        (claimedUntil == null ? 0 : claimedUntil.hashCode) +
        (decidedBy == null ? 0 : decidedBy.hashCode) +
        (decidedAt == null ? 0 : decidedAt.hashCode);

  factory ApplicationOut.fromJson(Map<String, dynamic> json) => _$ApplicationOutFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


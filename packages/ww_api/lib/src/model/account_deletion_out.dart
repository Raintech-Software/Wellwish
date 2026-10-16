//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_deletion_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AccountDeletionOut {
  /// Returns a new [AccountDeletionOut] instance.
  AccountDeletionOut({

    required  this.id,

    required  this.phoneLast4,

    required  this.status,

    required  this.createdAt,

    required  this.dueAt,

    required  this.cancelledAt,

    required  this.doneAt,

    required  this.keptPartner,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'phoneLast4',
    required: true,
    includeIfNull: false,
  )


  final String phoneLast4;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'dueAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime dueAt;



  @JsonKey(
    
    name: r'cancelledAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? cancelledAt;



  @JsonKey(
    
    name: r'doneAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? doneAt;



  @JsonKey(
    
    name: r'keptPartner',
    required: true,
    includeIfNull: false,
  )


  final bool keptPartner;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AccountDeletionOut &&
      other.id == id &&
      other.phoneLast4 == phoneLast4 &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.dueAt == dueAt &&
      other.cancelledAt == cancelledAt &&
      other.doneAt == doneAt &&
      other.keptPartner == keptPartner;

    @override
    int get hashCode =>
        id.hashCode +
        phoneLast4.hashCode +
        status.hashCode +
        createdAt.hashCode +
        dueAt.hashCode +
        (cancelledAt == null ? 0 : cancelledAt.hashCode) +
        (doneAt == null ? 0 : doneAt.hashCode) +
        keptPartner.hashCode;

  factory AccountDeletionOut.fromJson(Map<String, dynamic> json) => _$AccountDeletionOutFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDeletionOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


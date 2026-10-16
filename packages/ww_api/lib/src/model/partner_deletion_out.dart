//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_deletion_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerDeletionOut {
  /// Returns a new [PartnerDeletionOut] instance.
  PartnerDeletionOut({

    required  this.dueAt,

    required  this.done,
  });

      /// The personal data is erased after this time
  @JsonKey(
    
    name: r'dueAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime dueAt;



      /// Nothing to wait for (never registered): already erased
  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final bool done;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerDeletionOut &&
      other.dueAt == dueAt &&
      other.done == done;

    @override
    int get hashCode =>
        dueAt.hashCode +
        done.hashCode;

  factory PartnerDeletionOut.fromJson(Map<String, dynamic> json) => _$PartnerDeletionOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerDeletionOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/steps_out.dart';
import 'package:ww_api/src/model/application_out.dart';
import 'package:ww_api/src/model/doc_state_out.dart';
import 'package:ww_api/src/model/partner_profile_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kyc_status_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class KycStatusOut {
  /// Returns a new [KycStatusOut] instance.
  KycStatusOut({

    required  this.profile,

    required  this.steps,

    required  this.canEdit,

    required  this.canSubmit,

    required  this.documents,

    required  this.application,
  });

  @JsonKey(
    
    name: r'profile',
    required: true,
    includeIfNull: false,
  )


  final PartnerProfileOut profile;



  @JsonKey(
    
    name: r'steps',
    required: true,
    includeIfNull: false,
  )


  final StepsOut steps;



      /// Details can be changed (not while in review)
  @JsonKey(
    
    name: r'canEdit',
    required: true,
    includeIfNull: false,
  )


  final bool canEdit;



  @JsonKey(
    
    name: r'canSubmit',
    required: true,
    includeIfNull: false,
  )


  final bool canSubmit;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<DocStateOut> documents;



  @JsonKey(
    
    name: r'application',
    required: true,
    includeIfNull: true,
  )


  final ApplicationOut? application;





    @override
    bool operator ==(Object other) => identical(this, other) || other is KycStatusOut &&
      other.profile == profile &&
      other.steps == steps &&
      other.canEdit == canEdit &&
      other.canSubmit == canSubmit &&
      other.documents == documents &&
      other.application == application;

    @override
    int get hashCode =>
        profile.hashCode +
        steps.hashCode +
        canEdit.hashCode +
        canSubmit.hashCode +
        documents.hashCode +
        (application == null ? 0 : application.hashCode);

  factory KycStatusOut.fromJson(Map<String, dynamic> json) => _$KycStatusOutFromJson(json);

  Map<String, dynamic> toJson() => _$KycStatusOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


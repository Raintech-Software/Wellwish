//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/application_out.dart';
import 'package:ww_api/src/model/doc_state_out.dart';
import 'package:ww_api/src/model/partner_profile_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'application_detail_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApplicationDetailOut {
  /// Returns a new [ApplicationDetailOut] instance.
  ApplicationDetailOut({

    required  this.application,

    required  this.partner,

    required  this.documents,

    required  this.claimedByMe,

    required  this.canApprove,

    required  this.missingDocuments,
  });

  @JsonKey(
    
    name: r'application',
    required: true,
    includeIfNull: false,
  )


  final ApplicationOut application;



  @JsonKey(
    
    name: r'partner',
    required: true,
    includeIfNull: false,
  )


  final PartnerProfileOut partner;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<DocStateOut> documents;



  @JsonKey(
    
    name: r'claimedByMe',
    required: true,
    includeIfNull: false,
  )


  final bool claimedByMe;



  @JsonKey(
    
    name: r'canApprove',
    required: true,
    includeIfNull: false,
  )


  final bool canApprove;



  @JsonKey(
    
    name: r'missingDocuments',
    required: true,
    includeIfNull: false,
  )


  final List<String> missingDocuments;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApplicationDetailOut &&
      other.application == application &&
      other.partner == partner &&
      other.documents == documents &&
      other.claimedByMe == claimedByMe &&
      other.canApprove == canApprove &&
      other.missingDocuments == missingDocuments;

    @override
    int get hashCode =>
        application.hashCode +
        partner.hashCode +
        documents.hashCode +
        claimedByMe.hashCode +
        canApprove.hashCode +
        missingDocuments.hashCode;

  factory ApplicationDetailOut.fromJson(Map<String, dynamic> json) => _$ApplicationDetailOutFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDetailOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/history_out.dart';
import 'package:ww_api/src/model/document_out.dart';
import 'package:ww_api/src/model/application_out.dart';
import 'package:ww_api/src/model/doc_state_out.dart';
import 'package:ww_api/src/model/partner_profile_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_detail_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerDetailOut {
  /// Returns a new [PartnerDetailOut] instance.
  PartnerDetailOut({

    required  this.partner,

    required  this.documents,

    required  this.historyDocuments,

    required  this.application,

    required  this.history,
  });

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
    
    name: r'historyDocuments',
    required: true,
    includeIfNull: false,
  )


  final List<DocumentOut> historyDocuments;



  @JsonKey(
    
    name: r'application',
    required: true,
    includeIfNull: true,
  )


  final ApplicationOut? application;



  @JsonKey(
    
    name: r'history',
    required: true,
    includeIfNull: false,
  )


  final List<HistoryOut> history;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerDetailOut &&
      other.partner == partner &&
      other.documents == documents &&
      other.historyDocuments == historyDocuments &&
      other.application == application &&
      other.history == history;

    @override
    int get hashCode =>
        partner.hashCode +
        documents.hashCode +
        historyDocuments.hashCode +
        (application == null ? 0 : application.hashCode) +
        history.hashCode;

  factory PartnerDetailOut.fromJson(Map<String, dynamic> json) => _$PartnerDetailOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerDetailOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


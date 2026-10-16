//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_document_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalDocumentOut {
  /// Returns a new [LegalDocumentOut] instance.
  LegalDocumentOut({

    required  this.kind,

    required  this.version,

    required  this.isNewest,

    required  this.consentVersion,

    required  this.askedAgain,

    required  this.titleEn,

    required  this.titleHi,

    required  this.titleOr,

    required  this.bodyEn,

    required  this.bodyHi,

    required  this.bodyOr,

    required  this.publishedAt,

    required  this.publishedBy,

    required  this.publicUrl,
  });

  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final LegalDocumentOutKindEnum kind;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final int version;



  @JsonKey(
    
    name: r'isNewest',
    required: true,
    includeIfNull: false,
  )


  final bool isNewest;



  @JsonKey(
    
    name: r'consentVersion',
    required: true,
    includeIfNull: false,
  )


  final String consentVersion;



  @JsonKey(
    
    name: r'askedAgain',
    required: true,
    includeIfNull: false,
  )


  final bool askedAgain;



  @JsonKey(
    
    name: r'titleEn',
    required: true,
    includeIfNull: false,
  )


  final String titleEn;



  @JsonKey(
    
    name: r'titleHi',
    required: true,
    includeIfNull: false,
  )


  final String titleHi;



  @JsonKey(
    
    name: r'titleOr',
    required: true,
    includeIfNull: false,
  )


  final String titleOr;



  @JsonKey(
    
    name: r'bodyEn',
    required: true,
    includeIfNull: false,
  )


  final String bodyEn;



  @JsonKey(
    
    name: r'bodyHi',
    required: true,
    includeIfNull: false,
  )


  final String bodyHi;



  @JsonKey(
    
    name: r'bodyOr',
    required: true,
    includeIfNull: false,
  )


  final String bodyOr;



  @JsonKey(
    
    name: r'publishedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime publishedAt;



  @JsonKey(
    
    name: r'publishedBy',
    required: true,
    includeIfNull: true,
  )


  final String? publishedBy;



  @JsonKey(
    
    name: r'publicUrl',
    required: true,
    includeIfNull: false,
  )


  final String publicUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalDocumentOut &&
      other.kind == kind &&
      other.version == version &&
      other.isNewest == isNewest &&
      other.consentVersion == consentVersion &&
      other.askedAgain == askedAgain &&
      other.titleEn == titleEn &&
      other.titleHi == titleHi &&
      other.titleOr == titleOr &&
      other.bodyEn == bodyEn &&
      other.bodyHi == bodyHi &&
      other.bodyOr == bodyOr &&
      other.publishedAt == publishedAt &&
      other.publishedBy == publishedBy &&
      other.publicUrl == publicUrl;

    @override
    int get hashCode =>
        kind.hashCode +
        version.hashCode +
        isNewest.hashCode +
        consentVersion.hashCode +
        askedAgain.hashCode +
        titleEn.hashCode +
        titleHi.hashCode +
        titleOr.hashCode +
        bodyEn.hashCode +
        bodyHi.hashCode +
        bodyOr.hashCode +
        publishedAt.hashCode +
        (publishedBy == null ? 0 : publishedBy.hashCode) +
        publicUrl.hashCode;

  factory LegalDocumentOut.fromJson(Map<String, dynamic> json) => _$LegalDocumentOutFromJson(json);

  Map<String, dynamic> toJson() => _$LegalDocumentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum LegalDocumentOutKindEnum {
@JsonValue(r'TERMS')
TERMS(r'TERMS'),
@JsonValue(r'PRIVACY')
PRIVACY(r'PRIVACY'),
@JsonValue(r'REFUNDS')
REFUNDS(r'REFUNDS'),
@JsonValue(r'PARTNER_TERMS')
PARTNER_TERMS(r'PARTNER_TERMS');

const LegalDocumentOutKindEnum(this.value);

final String value;

@override
String toString() => value;
}



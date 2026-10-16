//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_summary_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalSummaryOut {
  /// Returns a new [LegalSummaryOut] instance.
  LegalSummaryOut({

    required  this.kind,

    required  this.title,

    required  this.version,

    required  this.consentVersion,

    required  this.askedAgain,

    required  this.languages,

    required  this.publishedAt,

     this.publishedBy,

    required  this.publicUrl,
  });

  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final LegalSummaryOutKindEnum kind;



      /// The English title
  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final int version;



  @JsonKey(
    
    name: r'consentVersion',
    required: true,
    includeIfNull: false,
  )


  final String consentVersion;



      /// Whether the newest version asked everyone again
  @JsonKey(
    
    name: r'askedAgain',
    required: true,
    includeIfNull: false,
  )


  final bool askedAgain;



      /// Languages written (en, hi, or)
  @JsonKey(
    
    name: r'languages',
    required: true,
    includeIfNull: false,
  )


  final List<String> languages;



  @JsonKey(
    
    name: r'publishedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime publishedAt;



      /// Empty for the first drafts
  @JsonKey(
    
    name: r'publishedBy',
    required: false,
    includeIfNull: false,
  )


  final String? publishedBy;



  @JsonKey(
    
    name: r'publicUrl',
    required: true,
    includeIfNull: false,
  )


  final String publicUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalSummaryOut &&
      other.kind == kind &&
      other.title == title &&
      other.version == version &&
      other.consentVersion == consentVersion &&
      other.askedAgain == askedAgain &&
      other.languages == languages &&
      other.publishedAt == publishedAt &&
      other.publishedBy == publishedBy &&
      other.publicUrl == publicUrl;

    @override
    int get hashCode =>
        kind.hashCode +
        title.hashCode +
        version.hashCode +
        consentVersion.hashCode +
        askedAgain.hashCode +
        languages.hashCode +
        publishedAt.hashCode +
        (publishedBy == null ? 0 : publishedBy.hashCode) +
        publicUrl.hashCode;

  factory LegalSummaryOut.fromJson(Map<String, dynamic> json) => _$LegalSummaryOutFromJson(json);

  Map<String, dynamic> toJson() => _$LegalSummaryOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum LegalSummaryOutKindEnum {
@JsonValue(r'TERMS')
TERMS(r'TERMS'),
@JsonValue(r'PRIVACY')
PRIVACY(r'PRIVACY'),
@JsonValue(r'REFUNDS')
REFUNDS(r'REFUNDS'),
@JsonValue(r'PARTNER_TERMS')
PARTNER_TERMS(r'PARTNER_TERMS');

const LegalSummaryOutKindEnum(this.value);

final String value;

@override
String toString() => value;
}



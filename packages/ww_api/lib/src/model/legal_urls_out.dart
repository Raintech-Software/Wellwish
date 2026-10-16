//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_urls_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalUrlsOut {
  /// Returns a new [LegalUrlsOut] instance.
  LegalUrlsOut({

    required  this.terms,

    required  this.privacy,

    required  this.refunds,

    required  this.partnerTerms,

    required  this.deleteAccount,
  });

  @JsonKey(
    
    name: r'terms',
    required: true,
    includeIfNull: false,
  )


  final String terms;



  @JsonKey(
    
    name: r'privacy',
    required: true,
    includeIfNull: false,
  )


  final String privacy;



  @JsonKey(
    
    name: r'refunds',
    required: true,
    includeIfNull: false,
  )


  final String refunds;



  @JsonKey(
    
    name: r'partnerTerms',
    required: true,
    includeIfNull: false,
  )


  final String partnerTerms;



  @JsonKey(
    
    name: r'deleteAccount',
    required: true,
    includeIfNull: false,
  )


  final String deleteAccount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalUrlsOut &&
      other.terms == terms &&
      other.privacy == privacy &&
      other.refunds == refunds &&
      other.partnerTerms == partnerTerms &&
      other.deleteAccount == deleteAccount;

    @override
    int get hashCode =>
        terms.hashCode +
        privacy.hashCode +
        refunds.hashCode +
        partnerTerms.hashCode +
        deleteAccount.hashCode;

  factory LegalUrlsOut.fromJson(Map<String, dynamic> json) => _$LegalUrlsOutFromJson(json);

  Map<String, dynamic> toJson() => _$LegalUrlsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


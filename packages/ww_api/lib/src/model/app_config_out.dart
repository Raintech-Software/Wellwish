//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/legal_urls_out.dart';
import 'package:ww_api/src/model/app_versions_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AppConfigOut {
  /// Returns a new [AppConfigOut] instance.
  AppConfigOut({

    required  this.minVersions,

    required  this.storeUrls,

    required  this.supportPhone,

    required  this.refundPercent,

    required  this.accountDeletionDays,

    required  this.legalUrls,
  });

      /// An app older than this shows the force-update screen
  @JsonKey(
    
    name: r'minVersions',
    required: true,
    includeIfNull: false,
  )


  final AppVersionsOut minVersions;



  @JsonKey(
    
    name: r'storeUrls',
    required: true,
    includeIfNull: false,
  )


  final AppVersionsOut storeUrls;



  @JsonKey(
    
    name: r'supportPhone',
    required: true,
    includeIfNull: false,
  )


  final String supportPhone;



  @JsonKey(
    
    name: r'refundPercent',
    required: true,
    includeIfNull: false,
  )


  final int refundPercent;



      /// Days before a 'delete my account' request is carried out
  @JsonKey(
    
    name: r'accountDeletionDays',
    required: true,
    includeIfNull: false,
  )


  final int accountDeletionDays;



  @JsonKey(
    
    name: r'legalUrls',
    required: true,
    includeIfNull: false,
  )


  final LegalUrlsOut legalUrls;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AppConfigOut &&
      other.minVersions == minVersions &&
      other.storeUrls == storeUrls &&
      other.supportPhone == supportPhone &&
      other.refundPercent == refundPercent &&
      other.accountDeletionDays == accountDeletionDays &&
      other.legalUrls == legalUrls;

    @override
    int get hashCode =>
        minVersions.hashCode +
        storeUrls.hashCode +
        supportPhone.hashCode +
        refundPercent.hashCode +
        accountDeletionDays.hashCode +
        legalUrls.hashCode;

  factory AppConfigOut.fromJson(Map<String, dynamic> json) => _$AppConfigOutFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


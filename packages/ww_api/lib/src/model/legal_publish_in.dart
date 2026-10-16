//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_publish_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalPublishIn {
  /// Returns a new [LegalPublishIn] instance.
  LegalPublishIn({

    required  this.expectedVersion,

    required  this.askAgain,

    required  this.titleEn,

     this.titleHi = '',

     this.titleOr = '',

    required  this.bodyEn,

     this.bodyHi = '',

     this.bodyOr = '',
  });

      /// The newest version you edited
          // minimum: 1
  @JsonKey(
    
    name: r'expectedVersion',
    required: true,
    includeIfNull: false,
  )


  final int expectedVersion;



      /// Everyone accepts it again at their next app open (else a small fix)
  @JsonKey(
    
    name: r'askAgain',
    required: true,
    includeIfNull: false,
  )


  final bool askAgain;



  @JsonKey(
    
    name: r'titleEn',
    required: true,
    includeIfNull: false,
  )


  final String titleEn;



  @JsonKey(
    defaultValue: '',
    name: r'titleHi',
    required: false,
    includeIfNull: false,
  )


  final String? titleHi;



  @JsonKey(
    defaultValue: '',
    name: r'titleOr',
    required: false,
    includeIfNull: false,
  )


  final String? titleOr;



  @JsonKey(
    
    name: r'bodyEn',
    required: true,
    includeIfNull: false,
  )


  final String bodyEn;



  @JsonKey(
    defaultValue: '',
    name: r'bodyHi',
    required: false,
    includeIfNull: false,
  )


  final String? bodyHi;



  @JsonKey(
    defaultValue: '',
    name: r'bodyOr',
    required: false,
    includeIfNull: false,
  )


  final String? bodyOr;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalPublishIn &&
      other.expectedVersion == expectedVersion &&
      other.askAgain == askAgain &&
      other.titleEn == titleEn &&
      other.titleHi == titleHi &&
      other.titleOr == titleOr &&
      other.bodyEn == bodyEn &&
      other.bodyHi == bodyHi &&
      other.bodyOr == bodyOr;

    @override
    int get hashCode =>
        expectedVersion.hashCode +
        askAgain.hashCode +
        titleEn.hashCode +
        titleHi.hashCode +
        titleOr.hashCode +
        bodyEn.hashCode +
        bodyHi.hashCode +
        bodyOr.hashCode;

  factory LegalPublishIn.fromJson(Map<String, dynamic> json) => _$LegalPublishInFromJson(json);

  Map<String, dynamic> toJson() => _$LegalPublishInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


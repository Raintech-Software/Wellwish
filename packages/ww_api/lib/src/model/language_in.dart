//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'language_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LanguageIn {
  /// Returns a new [LanguageIn] instance.
  LanguageIn({

    required  this.language,
  });

  @JsonKey(
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final LanguageInLanguageEnum language;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LanguageIn &&
      other.language == language;

    @override
    int get hashCode =>
        language.hashCode;

  factory LanguageIn.fromJson(Map<String, dynamic> json) => _$LanguageInFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum LanguageInLanguageEnum {
@JsonValue(r'en')
en(r'en'),
@JsonValue(r'hi')
hi(r'hi'),
@JsonValue(r'or')
or(r'or');

const LanguageInLanguageEnum(this.value);

final String value;

@override
String toString() => value;
}



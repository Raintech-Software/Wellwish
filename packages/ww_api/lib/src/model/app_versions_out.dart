//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_versions_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AppVersionsOut {
  /// Returns a new [AppVersionsOut] instance.
  AppVersionsOut({

    required  this.patientAndroid,

    required  this.patientIos,

    required  this.partnerAndroid,
  });

  @JsonKey(
    
    name: r'patientAndroid',
    required: true,
    includeIfNull: false,
  )


  final String patientAndroid;



  @JsonKey(
    
    name: r'patientIos',
    required: true,
    includeIfNull: false,
  )


  final String patientIos;



  @JsonKey(
    
    name: r'partnerAndroid',
    required: true,
    includeIfNull: false,
  )


  final String partnerAndroid;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AppVersionsOut &&
      other.patientAndroid == patientAndroid &&
      other.patientIos == patientIos &&
      other.partnerAndroid == partnerAndroid;

    @override
    int get hashCode =>
        patientAndroid.hashCode +
        patientIos.hashCode +
        partnerAndroid.hashCode;

  factory AppVersionsOut.fromJson(Map<String, dynamic> json) => _$AppVersionsOutFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


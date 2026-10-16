//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'steps_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StepsOut {
  /// Returns a new [StepsOut] instance.
  StepsOut({

    required  this.role,

    required  this.alternatePhone,

    required  this.email,

    required  this.profile,

    required  this.documents,
  });

  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final bool role;



  @JsonKey(
    
    name: r'alternatePhone',
    required: true,
    includeIfNull: false,
  )


  final bool alternatePhone;



  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final bool email;



  @JsonKey(
    
    name: r'profile',
    required: true,
    includeIfNull: false,
  )


  final bool profile;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final bool documents;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StepsOut &&
      other.role == role &&
      other.alternatePhone == alternatePhone &&
      other.email == email &&
      other.profile == profile &&
      other.documents == documents;

    @override
    int get hashCode =>
        role.hashCode +
        alternatePhone.hashCode +
        email.hashCode +
        profile.hashCode +
        documents.hashCode;

  factory StepsOut.fromJson(Map<String, dynamic> json) => _$StepsOutFromJson(json);

  Map<String, dynamic> toJson() => _$StepsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


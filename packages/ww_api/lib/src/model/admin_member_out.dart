//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_member_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminMemberOut {
  /// Returns a new [AdminMemberOut] instance.
  AdminMemberOut({

    required  this.id,

    required  this.relation,

    required  this.fullName,

    required  this.age,

    required  this.gender,

    required  this.phone,

    required  this.language,

    required  this.isActive,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'relation',
    required: true,
    includeIfNull: false,
  )


  final String relation;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'age',
    required: true,
    includeIfNull: true,
  )


  final int? age;



  @JsonKey(
    
    name: r'gender',
    required: true,
    includeIfNull: false,
  )


  final String gender;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final String language;



  @JsonKey(
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminMemberOut &&
      other.id == id &&
      other.relation == relation &&
      other.fullName == fullName &&
      other.age == age &&
      other.gender == gender &&
      other.phone == phone &&
      other.language == language &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        id.hashCode +
        relation.hashCode +
        fullName.hashCode +
        (age == null ? 0 : age.hashCode) +
        gender.hashCode +
        phone.hashCode +
        language.hashCode +
        isActive.hashCode;

  factory AdminMemberOut.fromJson(Map<String, dynamic> json) => _$AdminMemberOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminMemberOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


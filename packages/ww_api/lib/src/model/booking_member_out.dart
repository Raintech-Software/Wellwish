//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_member_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingMemberOut {
  /// Returns a new [BookingMemberOut] instance.
  BookingMemberOut({

     this.id,

    required  this.fullName,

    required  this.relation,

    required  this.gender,

    required  this.age,

    required  this.phone,

    required  this.language,
  });

      /// Empty once the member is gone
  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'relation',
    required: true,
    includeIfNull: false,
  )


  final String relation;



  @JsonKey(
    
    name: r'gender',
    required: true,
    includeIfNull: false,
  )


  final String gender;



  @JsonKey(
    
    name: r'age',
    required: true,
    includeIfNull: true,
  )


  final int? age;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingMemberOut &&
      other.id == id &&
      other.fullName == fullName &&
      other.relation == relation &&
      other.gender == gender &&
      other.age == age &&
      other.phone == phone &&
      other.language == language;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        fullName.hashCode +
        relation.hashCode +
        gender.hashCode +
        (age == null ? 0 : age.hashCode) +
        phone.hashCode +
        language.hashCode;

  factory BookingMemberOut.fromJson(Map<String, dynamic> json) => _$BookingMemberOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingMemberOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


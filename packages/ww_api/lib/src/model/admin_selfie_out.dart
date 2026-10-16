//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_selfie_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminSelfieOut {
  /// Returns a new [AdminSelfieOut] instance.
  AdminSelfieOut({

    required  this.id,

    required  this.partnerId,

    required  this.partnerName,

    required  this.role,

    required  this.at,

    required  this.selfieUrl,

    required  this.photoUrl,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'partnerId',
    required: true,
    includeIfNull: false,
  )


  final String partnerId;



  @JsonKey(
    
    name: r'partnerName',
    required: true,
    includeIfNull: false,
  )


  final String partnerName;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



  @JsonKey(
    
    name: r'selfieUrl',
    required: true,
    includeIfNull: true,
  )


  final String? selfieUrl;



  @JsonKey(
    
    name: r'photoUrl',
    required: true,
    includeIfNull: true,
  )


  final String? photoUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminSelfieOut &&
      other.id == id &&
      other.partnerId == partnerId &&
      other.partnerName == partnerName &&
      other.role == role &&
      other.at == at &&
      other.selfieUrl == selfieUrl &&
      other.photoUrl == photoUrl;

    @override
    int get hashCode =>
        id.hashCode +
        partnerId.hashCode +
        partnerName.hashCode +
        role.hashCode +
        at.hashCode +
        (selfieUrl == null ? 0 : selfieUrl.hashCode) +
        (photoUrl == null ? 0 : photoUrl.hashCode);

  factory AdminSelfieOut.fromJson(Map<String, dynamic> json) => _$AdminSelfieOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminSelfieOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentOut {
  /// Returns a new [DocumentOut] instance.
  DocumentOut({

    required  this.id,

    required  this.docType,

    required  this.status,

    required  this.mime,

    required  this.numberMasked,

    required  this.expiresOn,

    required  this.rejectReason,

    required  this.isCurrent,

    required  this.reviewedBy,

    required  this.reviewedAt,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'docType',
    required: true,
    includeIfNull: false,
  )


  final String docType;



      /// PENDING · APPROVED · REJECTED · EXPIRED
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'mime',
    required: true,
    includeIfNull: false,
  )


  final String mime;



  @JsonKey(
    
    name: r'numberMasked',
    required: true,
    includeIfNull: false,
  )


  final String numberMasked;



  @JsonKey(
    
    name: r'expiresOn',
    required: true,
    includeIfNull: true,
  )


  final DateTime? expiresOn;



  @JsonKey(
    
    name: r'rejectReason',
    required: true,
    includeIfNull: false,
  )


  final String rejectReason;



  @JsonKey(
    
    name: r'isCurrent',
    required: true,
    includeIfNull: false,
  )


  final bool isCurrent;



  @JsonKey(
    
    name: r'reviewedBy',
    required: true,
    includeIfNull: true,
  )


  final String? reviewedBy;



  @JsonKey(
    
    name: r'reviewedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? reviewedAt;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DocumentOut &&
      other.id == id &&
      other.docType == docType &&
      other.status == status &&
      other.mime == mime &&
      other.numberMasked == numberMasked &&
      other.expiresOn == expiresOn &&
      other.rejectReason == rejectReason &&
      other.isCurrent == isCurrent &&
      other.reviewedBy == reviewedBy &&
      other.reviewedAt == reviewedAt &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        docType.hashCode +
        status.hashCode +
        mime.hashCode +
        numberMasked.hashCode +
        (expiresOn == null ? 0 : expiresOn.hashCode) +
        rejectReason.hashCode +
        isCurrent.hashCode +
        (reviewedBy == null ? 0 : reviewedBy.hashCode) +
        (reviewedAt == null ? 0 : reviewedAt.hashCode) +
        createdAt.hashCode;

  factory DocumentOut.fromJson(Map<String, dynamic> json) => _$DocumentOutFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


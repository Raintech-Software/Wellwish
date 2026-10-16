//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/required_document_out.dart';
import 'package:ww_api/src/model/document_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_state_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocStateOut {
  /// Returns a new [DocStateOut] instance.
  DocStateOut({

    required  this.required_,

    required  this.status,

    required  this.document,

     this.replacement,
  });

  @JsonKey(
    
    name: r'required',
    required: true,
    includeIfNull: false,
  )


  final RequiredDocumentOut required_;



      /// MISSING · PENDING · APPROVED · REJECTED · EXPIRED
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'document',
    required: true,
    includeIfNull: true,
  )


  final DocumentOut? document;



      /// A renewal waiting for review (or rejected)
  @JsonKey(
    
    name: r'replacement',
    required: false,
    includeIfNull: false,
  )


  final DocumentOut? replacement;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DocStateOut &&
      other.required_ == required_ &&
      other.status == status &&
      other.document == document &&
      other.replacement == replacement;

    @override
    int get hashCode =>
        required_.hashCode +
        status.hashCode +
        (document == null ? 0 : document.hashCode) +
        (replacement == null ? 0 : replacement.hashCode);

  factory DocStateOut.fromJson(Map<String, dynamic> json) => _$DocStateOutFromJson(json);

  Map<String, dynamic> toJson() => _$DocStateOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_document_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingDocumentOut {
  /// Returns a new [BookingDocumentOut] instance.
  BookingDocumentOut({

    required  this.id,

    required  this.documentId,

    required  this.type,

    required  this.title,

    required  this.removed,
  });

      /// The attachment (stays when the document is deleted)
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'documentId',
    required: true,
    includeIfNull: true,
  )


  final String? documentId;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



      /// The patient deleted it after booking
  @JsonKey(
    
    name: r'removed',
    required: true,
    includeIfNull: false,
  )


  final bool removed;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingDocumentOut &&
      other.id == id &&
      other.documentId == documentId &&
      other.type == type &&
      other.title == title &&
      other.removed == removed;

    @override
    int get hashCode =>
        id.hashCode +
        (documentId == null ? 0 : documentId.hashCode) +
        type.hashCode +
        title.hashCode +
        removed.hashCode;

  factory BookingDocumentOut.fromJson(Map<String, dynamic> json) => _$BookingDocumentOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDocumentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


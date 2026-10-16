//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_storage_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentStorageOut {
  /// Returns a new [DocumentStorageOut] instance.
  DocumentStorageOut({

    required  this.usedBytes,

    required  this.quotaBytes,
  });

  @JsonKey(
    
    name: r'usedBytes',
    required: true,
    includeIfNull: false,
  )


  final int usedBytes;



  @JsonKey(
    
    name: r'quotaBytes',
    required: true,
    includeIfNull: false,
  )


  final int quotaBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DocumentStorageOut &&
      other.usedBytes == usedBytes &&
      other.quotaBytes == quotaBytes;

    @override
    int get hashCode =>
        usedBytes.hashCode +
        quotaBytes.hashCode;

  factory DocumentStorageOut.fromJson(Map<String, dynamic> json) => _$DocumentStorageOutFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentStorageOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


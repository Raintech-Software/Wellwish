// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_document_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingDocumentOutCWProxy {
  BookingDocumentOut id(String id);

  BookingDocumentOut documentId(String? documentId);

  BookingDocumentOut type(String type);

  BookingDocumentOut title(String title);

  BookingDocumentOut removed(bool removed);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingDocumentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingDocumentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingDocumentOut call({
    String id,
    String? documentId,
    String type,
    String title,
    bool removed,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingDocumentOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingDocumentOut.copyWith.fieldName(...)`
class _$BookingDocumentOutCWProxyImpl implements _$BookingDocumentOutCWProxy {
  const _$BookingDocumentOutCWProxyImpl(this._value);

  final BookingDocumentOut _value;

  @override
  BookingDocumentOut id(String id) => this(id: id);

  @override
  BookingDocumentOut documentId(String? documentId) =>
      this(documentId: documentId);

  @override
  BookingDocumentOut type(String type) => this(type: type);

  @override
  BookingDocumentOut title(String title) => this(title: title);

  @override
  BookingDocumentOut removed(bool removed) => this(removed: removed);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingDocumentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingDocumentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingDocumentOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? documentId = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? removed = const $CopyWithPlaceholder(),
  }) {
    return BookingDocumentOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      documentId: documentId == const $CopyWithPlaceholder()
          ? _value.documentId
          // ignore: cast_nullable_to_non_nullable
          : documentId as String?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      removed: removed == const $CopyWithPlaceholder()
          ? _value.removed
          // ignore: cast_nullable_to_non_nullable
          : removed as bool,
    );
  }
}

extension $BookingDocumentOutCopyWith on BookingDocumentOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingDocumentOut.copyWith(...)` or like so:`instanceOfBookingDocumentOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingDocumentOutCWProxy get copyWith =>
      _$BookingDocumentOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDocumentOut _$BookingDocumentOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingDocumentOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'documentId', 'type', 'title', 'removed'],
      );
      final val = BookingDocumentOut(
        id: $checkedConvert('id', (v) => v as String),
        documentId: $checkedConvert('documentId', (v) => v as String?),
        type: $checkedConvert('type', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        removed: $checkedConvert('removed', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$BookingDocumentOutToJson(BookingDocumentOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'type': instance.type,
      'title': instance.title,
      'removed': instance.removed,
    };

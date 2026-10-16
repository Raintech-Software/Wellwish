// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_detail_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerDetailOutCWProxy {
  PartnerDetailOut partner(PartnerProfileOut partner);

  PartnerDetailOut documents(List<DocStateOut> documents);

  PartnerDetailOut historyDocuments(List<DocumentOut> historyDocuments);

  PartnerDetailOut application(ApplicationOut? application);

  PartnerDetailOut history(List<HistoryOut> history);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerDetailOut call({
    PartnerProfileOut partner,
    List<DocStateOut> documents,
    List<DocumentOut> historyDocuments,
    ApplicationOut? application,
    List<HistoryOut> history,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerDetailOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerDetailOut.copyWith.fieldName(...)`
class _$PartnerDetailOutCWProxyImpl implements _$PartnerDetailOutCWProxy {
  const _$PartnerDetailOutCWProxyImpl(this._value);

  final PartnerDetailOut _value;

  @override
  PartnerDetailOut partner(PartnerProfileOut partner) => this(partner: partner);

  @override
  PartnerDetailOut documents(List<DocStateOut> documents) =>
      this(documents: documents);

  @override
  PartnerDetailOut historyDocuments(List<DocumentOut> historyDocuments) =>
      this(historyDocuments: historyDocuments);

  @override
  PartnerDetailOut application(ApplicationOut? application) =>
      this(application: application);

  @override
  PartnerDetailOut history(List<HistoryOut> history) => this(history: history);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerDetailOut call({
    Object? partner = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? historyDocuments = const $CopyWithPlaceholder(),
    Object? application = const $CopyWithPlaceholder(),
    Object? history = const $CopyWithPlaceholder(),
  }) {
    return PartnerDetailOut(
      partner: partner == const $CopyWithPlaceholder()
          ? _value.partner
          // ignore: cast_nullable_to_non_nullable
          : partner as PartnerProfileOut,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<DocStateOut>,
      historyDocuments: historyDocuments == const $CopyWithPlaceholder()
          ? _value.historyDocuments
          // ignore: cast_nullable_to_non_nullable
          : historyDocuments as List<DocumentOut>,
      application: application == const $CopyWithPlaceholder()
          ? _value.application
          // ignore: cast_nullable_to_non_nullable
          : application as ApplicationOut?,
      history: history == const $CopyWithPlaceholder()
          ? _value.history
          // ignore: cast_nullable_to_non_nullable
          : history as List<HistoryOut>,
    );
  }
}

extension $PartnerDetailOutCopyWith on PartnerDetailOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerDetailOut.copyWith(...)` or like so:`instanceOfPartnerDetailOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerDetailOutCWProxy get copyWith => _$PartnerDetailOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerDetailOut _$PartnerDetailOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartnerDetailOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'partner',
          'documents',
          'historyDocuments',
          'application',
          'history',
        ],
      );
      final val = PartnerDetailOut(
        partner: $checkedConvert(
          'partner',
          (v) => PartnerProfileOut.fromJson(v as Map<String, dynamic>),
        ),
        documents: $checkedConvert(
          'documents',
          (v) => (v as List<dynamic>)
              .map((e) => DocStateOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        historyDocuments: $checkedConvert(
          'historyDocuments',
          (v) => (v as List<dynamic>)
              .map((e) => DocumentOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        application: $checkedConvert(
          'application',
          (v) => v == null
              ? null
              : ApplicationOut.fromJson(v as Map<String, dynamic>),
        ),
        history: $checkedConvert(
          'history',
          (v) => (v as List<dynamic>)
              .map((e) => HistoryOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PartnerDetailOutToJson(
  PartnerDetailOut instance,
) => <String, dynamic>{
  'partner': instance.partner.toJson(),
  'documents': instance.documents.map((e) => e.toJson()).toList(),
  'historyDocuments': instance.historyDocuments.map((e) => e.toJson()).toList(),
  'application': instance.application?.toJson(),
  'history': instance.history.map((e) => e.toJson()).toList(),
};

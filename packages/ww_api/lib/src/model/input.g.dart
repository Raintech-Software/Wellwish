// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InputCWProxy {
  Input page(int? page);

  Input pageSize(int? pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Input(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Input(...).copyWith(id: 12, name: "My name")
  /// ````
  Input call({int? page, int? pageSize});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInput.copyWith.fieldName(...)`
class _$InputCWProxyImpl implements _$InputCWProxy {
  const _$InputCWProxyImpl(this._value);

  final Input _value;

  @override
  Input page(int? page) => this(page: page);

  @override
  Input pageSize(int? pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Input(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Input(...).copyWith(id: 12, name: "My name")
  /// ````
  Input call({
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return Input(
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as int?,
      pageSize: pageSize == const $CopyWithPlaceholder()
          ? _value.pageSize
          // ignore: cast_nullable_to_non_nullable
          : pageSize as int?,
    );
  }
}

extension $InputCopyWith on Input {
  /// Returns a callable class that can be used as follows: `instanceOfInput.copyWith(...)` or like so:`instanceOfInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InputCWProxy get copyWith => _$InputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Input _$InputFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Input',
  json,
  ($checkedConvert) {
    final val = Input(
      page: $checkedConvert('page', (v) => (v as num?)?.toInt() ?? 1),
      pageSize: $checkedConvert('pageSize', (v) => (v as num?)?.toInt() ?? 20),
    );
    return val;
  },
);

Map<String, dynamic> _$InputToJson(Input instance) => <String, dynamic>{
  'page': ?instance.page,
  'pageSize': ?instance.pageSize,
};

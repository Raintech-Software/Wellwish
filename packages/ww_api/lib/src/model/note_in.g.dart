// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NoteInCWProxy {
  NoteIn note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NoteIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NoteIn(...).copyWith(id: 12, name: "My name")
  /// ````
  NoteIn call({String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNoteIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNoteIn.copyWith.fieldName(...)`
class _$NoteInCWProxyImpl implements _$NoteInCWProxy {
  const _$NoteInCWProxyImpl(this._value);

  final NoteIn _value;

  @override
  NoteIn note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NoteIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NoteIn(...).copyWith(id: 12, name: "My name")
  /// ````
  NoteIn call({Object? note = const $CopyWithPlaceholder()}) {
    return NoteIn(
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $NoteInCopyWith on NoteIn {
  /// Returns a callable class that can be used as follows: `instanceOfNoteIn.copyWith(...)` or like so:`instanceOfNoteIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NoteInCWProxy get copyWith => _$NoteInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteIn _$NoteInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NoteIn', json, ($checkedConvert) {
      final val = NoteIn(
        note: $checkedConvert('note', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$NoteInToJson(NoteIn instance) => <String, dynamic>{
  'note': ?instance.note,
};

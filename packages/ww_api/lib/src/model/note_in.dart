//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NoteIn {
  /// Returns a new [NoteIn] instance.
  NoteIn({

     this.note = '',
  });

  @JsonKey(
    defaultValue: '',
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is NoteIn &&
      other.note == note;

    @override
    int get hashCode =>
        note.hashCode;

  factory NoteIn.fromJson(Map<String, dynamic> json) => _$NoteInFromJson(json);

  Map<String, dynamic> toJson() => _$NoteInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


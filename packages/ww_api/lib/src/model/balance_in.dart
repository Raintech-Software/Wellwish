//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balance_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BalanceIn {
  /// Returns a new [BalanceIn] instance.
  BalanceIn({

    required  this.amountPaise,

    required  this.mode,

     this.note = '',
  });

          // minimum: 0
          // maximum: 10000000
  @JsonKey(
    
    name: r'amountPaise',
    required: true,
    includeIfNull: false,
  )


  final int amountPaise;



  @JsonKey(
    
    name: r'mode',
    required: true,
    includeIfNull: false,
  )


  final BalanceInModeEnum mode;



  @JsonKey(
    defaultValue: '',
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BalanceIn &&
      other.amountPaise == amountPaise &&
      other.mode == mode &&
      other.note == note;

    @override
    int get hashCode =>
        amountPaise.hashCode +
        mode.hashCode +
        note.hashCode;

  factory BalanceIn.fromJson(Map<String, dynamic> json) => _$BalanceInFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum BalanceInModeEnum {
@JsonValue(r'CASH')
CASH(r'CASH'),
@JsonValue(r'UPI')
UPI(r'UPI');

const BalanceInModeEnum(this.value);

final String value;

@override
String toString() => value;
}



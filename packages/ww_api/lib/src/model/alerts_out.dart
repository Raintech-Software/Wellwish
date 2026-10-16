//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/alert_count_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alerts_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AlertsOut {
  /// Returns a new [AlertsOut] instance.
  AlertsOut({

    required  this.open,

    required  this.byKind,

    required  this.sosOpen,
  });

      /// Alerts nobody has marked as seen
  @JsonKey(
    
    name: r'open',
    required: true,
    includeIfNull: false,
  )


  final int open;



  @JsonKey(
    
    name: r'byKind',
    required: true,
    includeIfNull: false,
  )


  final List<AlertCountOut> byKind;



      /// SOS not resolved
  @JsonKey(
    
    name: r'sosOpen',
    required: true,
    includeIfNull: false,
  )


  final int sosOpen;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AlertsOut &&
      other.open == open &&
      other.byKind == byKind &&
      other.sosOpen == sosOpen;

    @override
    int get hashCode =>
        open.hashCode +
        byKind.hashCode +
        sosOpen.hashCode;

  factory AlertsOut.fromJson(Map<String, dynamic> json) => _$AlertsOutFromJson(json);

  Map<String, dynamic> toJson() => _$AlertsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


import 'package:json_annotation/json_annotation.dart';
import 'package:stagecon/widgets/TimerDisplay.dart';

part 'timer_event.g.dart';

enum TimerEventOperation {
  set,
  reset,
  start,
  stop,
  delete,
  format
}

enum TimerFormatOperation {
  color,
  msPrecision
}



@JsonSerializable()
class TimerEventOptions {
  final String? id;
  final TimerDisplayMode? mode;
  final Duration? startingAt;
  final bool? running;
  final TimerEventOperation operation;
  final String? subOperation;
  final DateTime? epochTime;
  final dynamic extraData;
  // final Color? countdownColor
  const TimerEventOptions({
    this.id,
    required this.operation,
    this.mode,
    this.startingAt,
    this.running,
    this.extraData,
    this.epochTime,
    this.subOperation
  });

  //json conversion
  factory TimerEventOptions.fromJson(Map<String, dynamic> json) => _$TimerEventOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$TimerEventOptionsToJson(this);


}
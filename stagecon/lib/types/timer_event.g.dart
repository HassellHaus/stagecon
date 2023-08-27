// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimerEventOptions _$TimerEventOptionsFromJson(Map<String, dynamic> json) =>
    TimerEventOptions(
      id: json['id'] as String?,
      operation: $enumDecode(_$TimerEventOperationEnumMap, json['operation']),
      mode: $enumDecodeNullable(_$TimerDisplayModeEnumMap, json['mode']),
      startingAt: json['startingAt'] == null
          ? null
          : Duration(microseconds: json['startingAt'] as int),
      running: json['running'] as bool?,
      extraData: json['extraData'],
      epochTime: json['epochTime'] == null
          ? null
          : DateTime.parse(json['epochTime'] as String),
      subOperation: json['subOperation'] as String?,
    );

Map<String, dynamic> _$TimerEventOptionsToJson(TimerEventOptions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mode': _$TimerDisplayModeEnumMap[instance.mode],
      'startingAt': instance.startingAt?.inMicroseconds,
      'running': instance.running,
      'operation': _$TimerEventOperationEnumMap[instance.operation]!,
      'subOperation': instance.subOperation,
      'epochTime': instance.epochTime?.toIso8601String(),
      'extraData': instance.extraData,
    };

const _$TimerEventOperationEnumMap = {
  TimerEventOperation.set: 'set',
  TimerEventOperation.reset: 'reset',
  TimerEventOperation.start: 'start',
  TimerEventOperation.stop: 'stop',
  TimerEventOperation.delete: 'delete',
  TimerEventOperation.format: 'format',
};

const _$TimerDisplayModeEnumMap = {
  TimerDisplayMode.countdown: 'countdown',
  TimerDisplayMode.stopwatch: 'stopwatch',
};

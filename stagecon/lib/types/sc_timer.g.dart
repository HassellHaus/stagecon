// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sc_timer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScTimerAdapter extends TypeAdapter<ScTimer> {
  @override
  final int typeId = 1;

  @override
  ScTimer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScTimer(
      initialStartingAt: fields[1] as Duration,
      msPrecision: fields[8] as int?,
      flashRate: fields[9] as int?,
      mode: fields[2] as TimerMode,
      color: fields[3] as Color,
      id: fields[4] as String?,
      createdAt: fields[5] as DateTime?,
    )
      .._running = fields[0] as bool
      ..startingAt = fields[10] as Duration
      ..epochTime = fields[11] as DateTime
      ..expiresAt = fields[6] as DateTime?
      ..expired = fields[7] as bool;
  }

  @override
  void write(BinaryWriter writer, ScTimer obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj._running)
      ..writeByte(1)
      ..write(obj.initialStartingAt)
      ..writeByte(10)
      ..write(obj.startingAt)
      ..writeByte(2)
      ..write(obj.mode)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.epochTime)
      ..writeByte(6)
      ..write(obj.expiresAt)
      ..writeByte(7)
      ..write(obj.expired)
      ..writeByte(8)
      ..write(obj.msPrecision)
      ..writeByte(9)
      ..write(obj.flashRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScTimerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimerModeAdapter extends TypeAdapter<TimerMode> {
  @override
  final int typeId = 2;

  @override
  TimerMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TimerMode.countdown;
      case 1:
        return TimerMode.stopwatch;
      default:
        return TimerMode.countdown;
    }
  }

  @override
  void write(BinaryWriter writer, TimerMode obj) {
    switch (obj) {
      case TimerMode.countdown:
        writer.writeByte(0);
        break;
      case TimerMode.stopwatch:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScTimer _$ScTimerFromJson(Map<String, dynamic> json) => ScTimer(
      initialStartingAt: json['initialStartingAt'] == null
          ? const Duration()
          : const DurationConverter()
              .fromJson(json['initialStartingAt'] as int),
      msPrecision: json['msPrecision'] as int?,
      flashRate: json['flashRate'] as int?,
      mode: $enumDecodeNullable(_$TimerModeEnumMap, json['mode']) ??
          TimerMode.countdown,
      color: json['color'] == null
          ? const Color(0xffffffff)
          : const ColorConverter().fromJson(json['color'] as int),
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    )
      .._running = json['running'] as bool
      ..startingAt =
          const DurationConverter().fromJson(json['startingAt'] as int)
      ..epochTime = DateTime.parse(json['epochTime'] as String)
      ..expiresAt = json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String)
      ..expired = json['expired'] as bool;

Map<String, dynamic> _$ScTimerToJson(ScTimer instance) => <String, dynamic>{
      'running': instance._running,
      'initialStartingAt':
          const DurationConverter().toJson(instance.initialStartingAt),
      'startingAt': const DurationConverter().toJson(instance.startingAt),
      'mode': _$TimerModeEnumMap[instance.mode]!,
      'color': const ColorConverter().toJson(instance.color),
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'epochTime': instance.epochTime.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'expired': instance.expired,
      'msPrecision': instance.msPrecision,
      'flashRate': instance.flashRate,
    };

const _$TimerModeEnumMap = {
  TimerMode.countdown: 'countdown',
  TimerMode.stopwatch: 'stopwatch',
};

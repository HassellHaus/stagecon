// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sc_cuelight.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScCueLightAdapter extends TypeAdapter<ScCueLight> {
  @override
  final int typeId = 5;

  @override
  ScCueLight read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScCueLight(
      id: fields[0] as String?,
      createdAt: fields[1] as DateTime?,
      color: fields[2] as Color,
      state: fields[3] as CueLightState,
      name: fields[4] as String?,
      fromRemote: fields[6] == null ? false : fields[6] as bool,
      toggleActive: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScCueLight obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.state)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.toggleActive)
      ..writeByte(6)
      ..write(obj.fromRemote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScCueLightAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CueLightStateAdapter extends TypeAdapter<CueLightState> {
  @override
  final int typeId = 6;

  @override
  CueLightState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CueLightState.inactive;
      case 1:
        return CueLightState.standby;
      case 2:
        return CueLightState.acknowledged;
      case 3:
        return CueLightState.active;
      default:
        return CueLightState.inactive;
    }
  }

  @override
  void write(BinaryWriter writer, CueLightState obj) {
    switch (obj) {
      case CueLightState.inactive:
        writer.writeByte(0);
        break;
      case CueLightState.standby:
        writer.writeByte(1);
        break;
      case CueLightState.acknowledged:
        writer.writeByte(2);
        break;
      case CueLightState.active:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CueLightStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScCueLight _$ScCueLightFromJson(Map<String, dynamic> json) => ScCueLight(
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      color: const ColorConverter().fromJson(json['color'] as int),
      state: $enumDecode(_$CueLightStateEnumMap, json['state']),
      name: json['name'] as String?,
      fromRemote: json['fromRemote'] as bool? ?? false,
      toggleActive: json['toggleActive'] as bool? ?? false,
    );

Map<String, dynamic> _$ScCueLightToJson(ScCueLight instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'color': const ColorConverter().toJson(instance.color),
      'state': _$CueLightStateEnumMap[instance.state]!,
      'name': instance.name,
      'toggleActive': instance.toggleActive,
      'fromRemote': instance.fromRemote,
    };

const _$CueLightStateEnumMap = {
  CueLightState.inactive: 'inactive',
  CueLightState.standby: 'standby',
  CueLightState.acknowledged: 'acknowledged',
  CueLightState.active: 'active',
};

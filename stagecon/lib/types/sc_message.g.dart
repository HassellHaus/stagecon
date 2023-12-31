// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sc_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScMessageAdapter extends TypeAdapter<ScMessage> {
  @override
  final int typeId = 7;

  @override
  ScMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScMessage(
      title: fields[1] as String,
      content: fields[2] as String?,
      ttl: fields[3] as Duration,
      id: fields[0] as String?,
      createdAt: fields[4] as DateTime?,
    )..senderName = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, ScMessage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.ttl)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.senderName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScMessage _$ScMessageFromJson(Map<String, dynamic> json) => ScMessage(
      title: json['title'] as String,
      content: json['content'] as String?,
      ttl: json['ttl'] == null
          ? const Duration(seconds: 5)
          : Duration(microseconds: json['ttl'] as int),
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    )..senderName = json['senderName'] as String?;

Map<String, dynamic> _$ScMessageToJson(ScMessage instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'ttl': instance.ttl.inMicroseconds,
      'createdAt': instance.createdAt.toIso8601String(),
      'senderName': instance.senderName,
    };
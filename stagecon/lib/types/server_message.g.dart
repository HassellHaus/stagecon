// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerMessage _$ServerMessageFromJson(Map<String, dynamic> json) =>
    ServerMessage(
      target: json['target'] as String,
      method: $enumDecode(_$ServerMessageMethodEnumMap, json['method']),
      dataType: $enumDecode(_$ServerMessageDataTypeEnumMap, json['dataType']),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ServerMessageToJson(ServerMessage instance) =>
    <String, dynamic>{
      'target': instance.target,
      'dataType': _$ServerMessageDataTypeEnumMap[instance.dataType]!,
      'method': _$ServerMessageMethodEnumMap[instance.method]!,
      'data': instance.data,
    };

const _$ServerMessageMethodEnumMap = {
  ServerMessageMethod.upsert: 'upsert',
  ServerMessageMethod.delete: 'delete',
};

const _$ServerMessageDataTypeEnumMap = {
  ServerMessageDataType.timer: 'timer',
  ServerMessageDataType.message: 'message',
  ServerMessageDataType.cuelight: 'cuelight',
};

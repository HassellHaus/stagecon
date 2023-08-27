// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerMessage _$ServerMessageFromJson(Map<String, dynamic> json) =>
    ServerMessage(
      timerEvent: json['timerEvent'] == null
          ? null
          : TimerEventOptions.fromJson(
              json['timerEvent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServerMessageToJson(ServerMessage instance) =>
    <String, dynamic>{
      'timerEvent': instance.timerEvent,
    };

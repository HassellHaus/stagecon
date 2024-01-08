// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_sync_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerSyncMessage _$ServerSyncMessageFromJson(Map<String, dynamic> json) =>
    ServerSyncMessage(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ScMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      timers: (json['timers'] as List<dynamic>)
          .map((e) => ScTimer.fromJson(e as Map<String, dynamic>))
          .toList(),
      cuelights: (json['cuelights'] as List<dynamic>)
          .map((e) => ScCueLight.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServerSyncMessageToJson(ServerSyncMessage instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'timers': instance.timers,
      'cuelights': instance.cuelights,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageEvent _$MessageEventFromJson(Map<String, dynamic> json) => MessageEvent(
      title: json['title'] as String,
      content: json['content'] as String?,
      ttl: json['ttl'] as int? ?? 3000,
    );

Map<String, dynamic> _$MessageEventToJson(MessageEvent instance) =>
    <String, dynamic>{
      'ttl': instance.ttl,
      'title': instance.title,
      'content': instance.content,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sc_message.dart';

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
    );

Map<String, dynamic> _$ScMessageToJson(ScMessage instance) => <String, dynamic>{
      'ttl': instance.ttl.inMicroseconds,
      'title': instance.title,
      'content': instance.content,
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

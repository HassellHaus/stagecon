import 'package:json_annotation/json_annotation.dart';
import 'package:stagecon/types/timer_event.dart';

part 'server_message.g.dart';

@JsonSerializable()
class ServerMessage {
  final TimerEventOptions? timerEvent;

  ServerMessage({this.timerEvent});

  factory ServerMessage.fromJson(Map<String, dynamic> json) => _$ServerMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ServerMessageToJson(this);

}
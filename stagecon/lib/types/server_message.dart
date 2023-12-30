import 'package:json_annotation/json_annotation.dart';

part 'server_message.g.dart';

enum ServerMessageDataType {
  timer,
  message,
  cuelight
}
enum ServerMessageMethod {
  upsert,
  delete
}


@JsonSerializable()
class ServerMessage {
  final String  target;
  final ServerMessageDataType dataType;
  final ServerMessageMethod method;

  // @JsonKey(fromJson: null, toJson: null )
  // final T? data;
  final Map<String,dynamic>? data;
  
  final DateTime epochTime = DateTime.now();

  ServerMessage({required this.target, required this.method, required this.dataType, this.data});

  factory ServerMessage.fromJson(Map<String, dynamic> json) {
    return _$ServerMessageFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ServerMessageToJson(this);

}
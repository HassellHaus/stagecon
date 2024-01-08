import 'package:json_annotation/json_annotation.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/types/sc_message.dart';
import 'package:stagecon/types/sc_timer.dart';
part 'server_sync_message.g.dart';

@JsonSerializable()
class ServerSyncMessage {
  List<ScMessage> messages;
  List<ScTimer> timers;
  List<ScCueLight> cuelights;

  ServerSyncMessage({required this.messages, required this.timers, required this.cuelights});

  factory ServerSyncMessage.fromJson(Map<String, dynamic> json, {bool fromRemote = false}) {
    //loop through the messages and set fromRemote to true
    if(json["messages"] != null) {
      for(var message in json["messages"]) {
        message["fromRemote"] = fromRemote;
      }
    }
    if(json["timers"] != null) {
      for(var timer in json["timers"]) {
        timer["fromRemote"] = fromRemote;
      }
    }
    if(json["cuelights"] != null) {
      for(var cuelight in json["cuelights"]) {
        cuelight["fromRemote"] = fromRemote;
      }
    }
    
    
    return _$ServerSyncMessageFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ServerSyncMessageToJson(this);

}
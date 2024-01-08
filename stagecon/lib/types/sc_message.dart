import 'package:hive/hive.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/types/shared_types.dart';
import 'package:uuid/uuid.dart';


import 'package:json_annotation/json_annotation.dart';
// import 'package:stagecon/types/events/SCEvent.dart';


part 'sc_message.g.dart';

var _messageBox = Hive.box<ScMessage>("messages");
var _preferencesBox = Hive.box("preferences");

@HiveType(typeId: 7)
@JsonSerializable()
class ScMessage {
  @HiveField(0)
  late String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? content;

  @HiveField(3)
  final Duration ttl;


  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  String? senderName;

  @HiveField(6)
  String? senderDeviceId;
  
  @HiveField(7, defaultValue: false)
  final bool fromRemote;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get ttlExpired => DateTime.now().isAfter(createdAt.add(ttl));

  // @JsonKey(includeFromJson: false, includeToJson: true)
  // DateTime? get  expiresAt { // expire after 10 minutes + ttl
  //   return createdAt.add(Duration(minutes: 10, seconds:  ttl.inSeconds));
  // }


  // set expiresAt(DateTime? value) => { };


  

  // bool get expired => expiresAt != null && DateTime.now().isAfter(expiresAt!);


  final String type = "message";

  ScMessage({
    required this.title,
    this.content,
    this.ttl = const Duration(seconds: 10),
    this.fromRemote = false,
    String? senderName,
    String? senderDeviceId,
    String? id, DateTime? createdAt}) {
      this.id = id ?? const Uuid().v4();
      this.createdAt = createdAt ?? DateTime.timestamp();

      this.senderName = senderName ?? _preferencesBox.get("name");
      this.senderDeviceId = senderDeviceId ?? _preferencesBox.get("device_id");


    }


  factory ScMessage.fromJson(Map<String, dynamic> json) => _$ScMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ScMessageToJson(this);
  

  // @override
  // void from(ScEventInterface event) {
  //   if(event.type != type) throw Exception("Cannot convert ${event.type} to ${this.type}");
  //   event as ScMessageEvent;
  //   id = event.id;
  //   createdAt = event.createdAt;
  //   expiresAt = event.expiresAt;
  //   title = event.title;
  //   content = event.content;
  // }

  String get dbId => "${fromRemote ? "remote" : "local"}_$id";

  Future<void> upsert() async {
    await _messageBox.put(dbId, this);
    // notifyListeners();
    
  }

  static ScMessage? get(String id) {
    return _messageBox.get(id);
  }

  static Future<void> delete(String id) {
    return _messageBox.delete(id);
  }

  static void deleteAll() {
    _messageBox.clear();
  }

  ///Deletes all the messages that were created from a remote source  
  static Future<List<void>> deleteAllRemote() {
    return Future.wait(_messageBox.values.where((element) => element.fromRemote).map((element) {
      return ScMessage.delete(element.dbId);
    }));
  }

}
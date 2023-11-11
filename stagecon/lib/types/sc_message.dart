import 'package:uuid/uuid.dart';


import 'package:json_annotation/json_annotation.dart';
// import 'package:stagecon/types/events/SCEvent.dart';


part 'sc_message.g.dart';

@JsonSerializable()
class ScMessage {
  

  final Duration ttl;
  String title;
  String? content;


  late String id;


  late DateTime createdAt;
  
  

  @JsonKey(includeFromJson: false, includeToJson: true)
  DateTime? get  expiresAt { // expire after 10 minutes + ttl
    return createdAt.add(Duration(minutes: 10, seconds:  ttl.inSeconds));
  }


  set expiresAt(DateTime? value) => { };


  

  bool get expired => expiresAt != null && DateTime.now().isAfter(expiresAt!);


  final String type = "message";

  ScMessage({
    required this.title,
    this.content,
    this.ttl = const Duration(seconds: 5),
    String? id, DateTime? createdAt}) {
      this.id = id ?? const Uuid().v4();
      this.createdAt = createdAt ?? DateTime.timestamp();

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
}
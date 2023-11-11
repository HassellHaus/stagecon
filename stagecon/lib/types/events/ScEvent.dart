// //interface for all events



// import 'package:json_annotation/json_annotation.dart';
// import 'package:uuid/uuid.dart';



// part 'ScEvent.g.dart';

// @JsonSerializable()
// class ScEvent {
//   late String id;
//   late DateTime createdAt;
//   DateTime? expiresAt;

//   ScEvent({String? id, DateTime? createdAt, this.expiresAt}) {
//     this.id = id ?? const Uuid().v4();
//     this.createdAt = createdAt ?? DateTime.timestamp();
//   }

//   bool get expired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  
//     factory ScEvent.fromJson(Map<String, dynamic> json) => _$ScEventFromJson(json);
//     Map<String, dynamic> toJson() => _$ScEventToJson(this);
  
// }
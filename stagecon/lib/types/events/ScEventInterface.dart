// // import 'package:stagecon/types/events/ScMessageEvent.dart';



// interface class ScEventInterface extends ChangeNotifier{
//   late String id;
//   late DateTime createdAt;
//   DateTime? expiresAt;
//   final String type = "interface";

//   bool get expired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  
//   factory ScEventInterface.fromJson(Map<String, dynamic> json) {throw UnimplementedError();}
//   Map<String, dynamic> toJson() {throw UnimplementedError();}

//   void changed() {
//     notifyListeners();
//   }

//   // void from(ScEventInterface event) {
//   //   if(event.type != type) throw Exception("Cannot convert ${event.type} to ${this.type}");
//   //   id = event.id;
//   //   createdAt = event.createdAt;
//   //   expiresAt = event.expiresAt;
//   // }
// }

// // //create mixin 
// // mixin ScEventMixin {


// //   bool get expired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  
  
// // }

// // import 'package:stagecon/types/events/SCEvent.dart';

// // ScEventInterface event = ScMessageEvent(title: "test");

// // test() {
  
// //   if(event is ScMessageEvent) {
// //     (event as ScMessageEvent).content = "test";
    
// //     print("is ScMessageEvent");
// //   }
// // }
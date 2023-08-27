// import 'package:hive/hive.dart';
// import 'package:shelf/shelf.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/types/message_event.dart';
import 'package:stagecon/types/server_message.dart';
import 'package:stagecon/types/timer_event.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerProxyServer {
  OSCcontroler oscCon = Get.find();
  List<WebSocketChannel> sockets = [];
  void serve() async {
    var handler = webSocketHandler((WebSocketChannel webSocket) {
      
      if(webSocket.closeCode != null) {
        print("Removing Closed Websocket.  Previous Length: ${sockets.length}");
        sockets.remove(webSocket);
        print("New Length: ${sockets.length}");
        return;
      } else {
        print("New Websocket: ${sockets.length+1}");
      }
      sockets.add(webSocket);
      
      webSocket.stream.listen((message) {
        print(message);
        webSocket.sink.add("echo $message");
      });
    });
    
    var preferences = await Hive.box('preferences');
    var server = await shelf_io.serve(handler, '192.168.1.223', preferences.get("server_port") ?? 5566).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });

    oscCon.addTimerEventListener(onTimerEvent);

  }

  onTimerEvent(TimerEventOptions options) {
    for(var socket in sockets) {
      socket.sink.add(jsonEncode(ServerMessage(timerEvent: options).toJson()));
    }
  }

  onMessageEvent(MessageEvent options) {
    for(var socket in sockets) {
      socket.sink.add(jsonEncode(ServerMessage(messageEvent: options).toJson()));
    }
  }


  // @override
  void dispose() {
    // super.dispose();
    oscCon.removeTimerEventListener(onTimerEvent);
  }
}
//     // var handler =
//     //     const Pipeline().addMiddleware(logRequests()).addHandler(() {
//     //       return;
//     //     });

//     // var server = await shelf_io.serve(handler, 'localhost', 8080);

//     // // Enable content compression
//     // server.autoCompress = true;



//     // print('Serving at http://${server.address.host}:${server.port}');

//     var preferences = await Hive.box('preferences');

//     var handler = SseHandler(Uri.parse('/osc'));
//     await shelf_io.serve(handler.handler, 'localhost', preferences.get("server_port"));
//     var connections = handler.connections;
//     // connections.
//     while (await connections.hasNext) {
//       var connection = await connections.next;
//       // connection.
//       connection.sink.add('foo');
//       connection.stream.listen(print);
//     }

//   }
// }
import 'dart:convert';
import 'dart:io';

// import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/controllers/app_state.dart';
import 'package:stagecon/server_proxy/client.dart';
import 'package:stagecon/server_proxy/proxy_controller.dart';
import 'package:stagecon/server_proxy/server.dart';
import 'package:stagecon/type_converters.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/types/sc_message.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/views/fullscreen_view.dart';
import 'package:stagecon/views/main_view.dart';
import 'package:uuid/uuid.dart';

void _createStarterCuelights() async  {
    await ScCueLight(id: "red", name: "Red", color: Colors.red, state: CueLightState.inactive).upsert();
    await ScCueLight(id: "green", name: "Green", color: Colors.green, state: CueLightState.inactive).upsert();
    await ScCueLight(id: "blue", name: "Blue", color: Colors.blue, state: CueLightState.inactive).upsert();
    await ScCueLight(id: "yellow", name: "Yellow", color: Colors.yellow, state: CueLightState.inactive).upsert();
    await ScCueLight(id: "purple", name: "Purple", color: Colors.purple, state: CueLightState.inactive).upsert();
    await ScCueLight(id: "orange", name: "Orange", color: Colors.orange, state: CueLightState.inactive).upsert();
    await ScCueLight(id: "teal", name: "Teal", color: Colors.teal, state: CueLightState.inactive).upsert();
    await ScCueLight(id: "brown", name: "Brown", color: Colors.brown, state: CueLightState.inactive).upsert();
}

void main(List<String> args) async {
  print(args);
  // if (args.firstOrNull == 'multi_window') {
  //   final windowId = int.parse(args[1]);
  //   final argument = args[2].isEmpty
  //       ? const {} as Map<String, dynamic>
  //       : jsonDecode(args[2]) as Map<String, dynamic>;
  //   runApp(FullScreenSubWindowApp(
  //     windowController: WindowController.fromWindowId(windowId),
  //     args: argument,
  //   ));
  //   return;
  // } 

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isMacOS) {
    _configureMacosWindowUtils();
  }

  await Hive.initFlutter();

  // Hive.deleteBoxFromDisk("timers");
  Hive.registerAdapter(ScTimerAdapter());
  Hive.registerAdapter(TimerModeAdapter());
  Hive.registerAdapter(HiveDurationAdapter());
  Hive.registerAdapter(HiveColorAdapter());
  Hive.registerAdapter(ScCueLightAdapter());
  Hive.registerAdapter(CueLightStateAdapter());
  Hive.registerAdapter(ScMessageAdapter());

  var preferences = await Hive.openBox('preferences');
  var timerBox = await Hive.openBox<ScTimer>('timers');
  var cuelightBox = await Hive.openBox<ScCueLight>('cuelights');
  var messageBox = await Hive.openBox<ScMessage>('messages');
// cuelightBox.clear();
  if(cuelightBox.isEmpty) {
    _createStarterCuelights();
  }

  //set defaults
  if (!preferences.containsKey("osc_server_port")) {
    preferences.put("osc_server_port", 4455); // in OSC screen
  }

  // preferences.put("proxy_server_port", 5566);
  if (!preferences.containsKey("proxy_server_port")) {
    preferences.put("proxy_server_port", 5566); // in proxy server screen
  }
  if (!preferences.containsKey("proxy_server_enabled")) {
    // if enabled this app will become a server
    preferences.put("proxy_server_enabled", false); // in proxy server screen
  }

  //proxyu client
  if (!preferences.containsKey("proxy_client_enabled")) {
    // if enabled this app will become a client
    preferences.put("proxy_client_enabled", false); // in proxy server screen
  }
  if (!preferences.containsKey("proxy_client_ip")) {
    // if not null this app will become a client and attempt to connect to the server at this ip
    preferences.put("proxy_client_ip", null); // in proxy server screen
  }
  if (!preferences.containsKey("proxy_client_port")) {
    preferences.put("proxy_client_port", 5566); // in proxy server screen
  }

// if(!preferences.containsKey("proxy_client_url")) {
//     preferences.put("proxy_client_url", null);
//   }
  if (!preferences.containsKey("default_ms_precision")) {
    // in preferences screen
    preferences.put("default_ms_precision", 1);
  }
  if (!preferences.containsKey("default_countdown_flash_rate")) {
    //  in preferences screen
    preferences.put("default_countdown_flash_rate", 500);
  }
  if (!preferences.containsKey("telemetry")) {
    // in preferences screen
    preferences.put("telemetry", false);
  }
  if (!preferences.containsKey("full_screen_mode")) {
    preferences.put("full_screen_mode", false);
  }

  //misc 
  if (!preferences.containsKey("device_id")) {
    preferences.put("device_id", const Uuid().v4()); 
  }

  //listen for changes in port info for the osc controller via hive and then re initalize it

  var oscCon = Get.put(OSCcontroler(
    port: preferences.get("osc_server_port", defaultValue: 4455)
  ));
  Get.put(ProxyController());
  Get.put(AppState());
  // if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   var server = ScProxyServer();
  //   server.serve();
  // } else {
  //   var client = ScProxyClient(wsUrl: Uri.parse('ws://192.168.1.242:5566'));

  //   // client.listen();

  // }

  
  
  
  runApp(const MyApp());
  


  
}


// class FullScreenSubWindowApp extends StatelessWidget {
//   const FullScreenSubWindowApp({
//     Key? key,
//     required this.windowController,
//     required this.args,
//   }) : super(key: key);

//   final WindowController windowController;
//   final Map<String, dynamic> args;

//   @override
//   Widget build(BuildContext context) {
//     return MacosApp(
//       theme: MacosThemeData.light(),
//       home: MacosWindow(
        
//         child: FullScreenView(tapToClose: false,)
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    OSCcontroler oscCon = Get.find();
    ProxyController proxyController = Get.find();
    return Portal(
        child: GetMaterialApp(
            // debugShowCheckedModeBanner: false,
            onDispose: () {
              oscCon.dispose();
              proxyController.dispose();
            },
            themeMode: ThemeMode.system,
            title: 'StageCon',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.red,
            ),
            builder: (context, child) {
              return MacosApp(
                  // themeMode: ThemeMode.system,
                  theme: MacosThemeData(primaryColor: CupertinoColors.systemRed.resolveFrom(context)
                      //MacosColors.controlAccentColor// ?? CupertinoColors.systemRed.resolveFrom(context)
                      ),
                  darkTheme: MacosThemeData(brightness: Brightness.dark, primaryColor: CupertinoColors.systemRed.resolveFrom(context)
                      //MacosColors.controlAccentColor// ?? CupertinoColors.systemRed.resolveFrom(context)
                      ),
                  // color: CupertinoColors.systemRed.resolveFrom(context),
                  home: Builder(builder: (context) => CupertinoTheme(data: CupertinoThemeData(brightness: MacosTheme.of(context).brightness, primaryColor: CupertinoColors.systemRed.resolveFrom(context)), child: child!)));
            },
            home: const MainView()));
  }
}

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

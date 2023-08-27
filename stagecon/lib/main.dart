import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/server_proxy/client.dart';
import 'package:stagecon/server_proxy/server.dart';
import 'package:stagecon/views/TimeView.dart';
import 'package:stagecon/widgets/TimeDisplay.dart';

void main() async  {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  var preferences = await Hive.openBox('preferences');
  //set defaults
  if(!preferences.containsKey("osc_port")) {
    preferences.put("osc_port", 4455);
  }
  if(!preferences.containsKey("server_port")) {
    preferences.put("osc_port", 5566);
  }
  if(!preferences.containsKey("proxy_server_ip")) {
    preferences.put("proxy_server_ip", null);
  }
if(!preferences.containsKey("proxy_client_url")) {
    preferences.put("proxy_client_url", null);
  }
  if(!preferences.containsKey("default_ms_precision")) {
    preferences.put("default_ms_precision", 1);
  }
  if(!preferences.containsKey("default_countdown_flash_rate")) {
    preferences.put("default_countdown_flash_rate", 500);
  }
  if(!preferences.containsKey("telemetry")) {
    preferences.put("telemetry", false);
  }

  var oscCon = Get.put(OSCcontroler());
  if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    var server = ServerProxyServer();
    server.serve();
  } else {
    var client = ServerProxyClient(wsUrl: Uri.parse('ws://192.168.1.223:5566'));
    
    // client.listen();
    
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget  {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    OSCcontroler oscCon = Get.find();
    return GetMaterialApp(
      // debugShowCheckedModeBanner: false,
      onDispose: () {
        oscCon.dispose();
      },
      themeMode: ThemeMode.dark,
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
        primarySwatch: Colors.blue,
        
      ),
      home: const TimeView()
    );
  }
}


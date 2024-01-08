

import 'dart:async';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stagecon/server_proxy/client.dart';
import 'package:stagecon/server_proxy/server.dart';

class ProxyController extends GetxController {
  ScProxyServer server = ScProxyServer();
  ScProxyClient client = ScProxyClient();

  final _pref = Hive.box("preferences");

  late StreamSubscription<BoxEvent> _proxyServerEnabledSubscription;
  late StreamSubscription<BoxEvent> _proxyServerPortSubscription;

  late StreamSubscription<BoxEvent> _proxyClientEnabledSubscription;
  late StreamSubscription<BoxEvent> _proxyClientIpSubscription;
  late StreamSubscription<BoxEvent> _proxyClientPortSubscription;

  ProxyController() {
    //hive server 
    _proxyServerEnabledSubscription = _pref.watch(key:"proxy_server_enabled").listen(handleServerConfigChanges);
    _proxyServerPortSubscription = _pref.watch(key:"proxy_server_port").listen(handleServerConfigChanges);

    _proxyClientEnabledSubscription = _pref.watch(key:"proxy_client_enabled").listen(handleClientConfigChanges);
    _proxyClientIpSubscription = _pref.watch(key:"proxy_client_ip").listen(handleClientConfigChanges);
    _proxyClientPortSubscription = _pref.watch(key:"proxy_client_port").listen(handleClientConfigChanges);

    //chack if server is enabled
    if(_pref.get("proxy_server_enabled", defaultValue: false) as bool) {
      server.serve(port: _pref.get("proxy_server_port", defaultValue: 5566) as int);
    }
    //check if client should try to connect
    if(_pref.get("proxy_client_enabled", defaultValue: false) as bool) {
      //check if there is an ip and port 
      var ip = _pref.get("proxy_client_ip", defaultValue: null);
      var port = _pref.get("proxy_client_port", defaultValue: null);
      if(ip == null || port == null) {
        print("No ip or port set for client");
        _pref.put("proxy_client_enabled", false);
        return;
      }
      client.host = ip;
      client.port = port;
      client.reconnect();
    }
  }

  void handleServerConfigChanges(BoxEvent event) {
    if(_pref.get("proxy_server_enabled", defaultValue: false) as bool) {
      if(event.key == "proxy_server_enabled") {
        server.serve(port: _pref.get("proxy_server_port", defaultValue: 5566) as int);
      }
      if(event.key == "proxy_server_port") {
        server.serve(port: event.value as int);
      }
    } else {
      server.shutdown();

    }
  }

  void handleClientConfigChanges(BoxEvent event) {
    if(_pref.get("proxy_client_enabled", defaultValue: false) as bool) {
      //check if there is an ip and port 
      var ip = _pref.get("proxy_client_ip", defaultValue: null);
      var port = _pref.get("proxy_client_port", defaultValue: null);
      if(ip == null || port == null) {
        print("No ip or port set for client");
        _pref.put("proxy_client_enabled", false);
        return;
      }
      if(event.key == "proxy_client_enabled") {
        client.dispose();
        client = ScProxyClient();
        client.host = ip;
        client.port = port;
        client.reconnect();

      }

    } else {
      client.disconnect();
    }
    
  }

  @override
  void dispose() {
    server.dispose();
    client.dispose();
    _proxyServerPortSubscription.cancel();
    _proxyServerEnabledSubscription.cancel();
    _proxyClientEnabledSubscription.cancel();
    _proxyClientIpSubscription.cancel();
    _proxyClientPortSubscription.cancel();

    super.dispose();
  }
}
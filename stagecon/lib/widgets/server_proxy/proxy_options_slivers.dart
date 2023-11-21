import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:stagecon/server_proxy/proxy_controller.dart';
import 'package:stagecon/server_proxy/server.dart';
import 'package:stagecon/widgets/network_info_list_section.dart';
import 'package:stagecon/widgets/server_proxy/proxy_activity_indicator.dart';

class ProxyOptionsSlivers extends StatefulWidget {
  const ProxyOptionsSlivers({super.key});

  @override
  State<ProxyOptionsSlivers> createState() => _ProxyOptionsSliversState();
}

class _ProxyOptionsSliversState extends State<ProxyOptionsSlivers> {
  ProxyController proxyController = Get.find();
  var _pref = Hive.box("preferences");

  late var proxyClientIp = TextEditingController(text: _pref.get("proxy_client_ip") as String?);
  late var proxyClientPort = TextEditingController(text: (_pref.get("proxy_client_port") as int?).toString());
  late var proxyServerPort = TextEditingController(text: (_pref.get("proxy_server_port") as int?).toString());

  @override
  void dispose() {
    proxyClientIp.dispose();
    proxyClientPort.dispose();
    proxyServerPort.dispose();
    super.dispose();
  }
  // late bool _serverEnabled = proxyController.server != null;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        //server state
        SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
          backgroundColor: const Color(0x00ffffff),
          children: const [
            CupertinoListTile.notched(title: Text("Proxy Status"), trailing: ProxyActivityIndicator()),
          ],
        )),

        //client settings

        SliverToBoxAdapter(
            child: ValueListenableBuilder(
                valueListenable: _pref.listenable(keys: ["proxy_client_enabled", "proxy_client_enabled", "proxy_client_port"]),
                builder: (BuildContext context, box, Widget? child) {
                  return CupertinoFormSection.insetGrouped(
                    header: const Text("Client"),
                    backgroundColor: const Color(0x00ffffff),
                    children: [
                      //mark: //connect or disconnect to server

                      CupertinoListTile.notched(
                          title: const Text("Connect to Proxy Server"),
                          trailing: CupertinoCheckbox(
                              value: box.get("proxy_client_enabled", defaultValue: false) as bool,
                              onChanged: (value) {
                                print(value);
                                box.put("proxy_client_enabled", value);
                              })),

                      CupertinoFormRow(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                        prefix: const Text("Server IP "),
                        child: 
                               MacosTextField(
                                controller: proxyClientIp,
                                keyboardType: TextInputType.number,
                                // prefix: Text("Server IP"),
                                onChanged: (value) {
                                  box.put("proxy_client_ip", value);
                                },
                              ),
                      ),

                      CupertinoFormRow(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                        prefix: const Text("Port "),
                        child: MacosTextField(
                                controller: proxyClientPort,
                                keyboardType: TextInputType.number,
                                // prefix: Text("Server IP"),
                                onChanged: (value) {
                                  box.put("proxy_client_port", int.tryParse(value));
                                },
                              )
                            
                      ),
                    ],
                  );
                })),

        //connect or disconnect to server
        //server ip

        // SliverToBoxAdapter(
        //   child: ValueListenableBuilder(
        //         valueListenable:
        //             _pref.listenable(keys: ["proxy_client_enabled", "proxy_client_port"]),
        //         builder: (BuildContext context, box, Widget? child) {
        //           return MacosTextField(
        //                     controller: proxyClientIp,
        //                     prefix: Text("Server IP"),
        //                     onChanged: (value) {
        //                       box.put("proxy_client_ip", value);
        //                     },
        //                   );
        //         })
        // ),

        //server settings

        SliverToBoxAdapter(
            child: ValueListenableBuilder(
                valueListenable: _pref.listenable(keys: ["proxy_server_port", "proxy_server_enabled"]),
                builder: (BuildContext context, box, Widget? child) {
                  return CupertinoFormSection.insetGrouped(
                    header: const Text("Server"),
                    backgroundColor: const Color(0x00ffffff),
                    children: [
                      //mark: //enable or disable proxy
                      CupertinoListTile.notched(
                          title: const Text("Enable Server"),
                          trailing: CupertinoCheckbox(
                              value: box.get("proxy_server_enabled", defaultValue: false) as bool,
                              onChanged: (value) {
                                print(value);
                                box.put("proxy_server_enabled", value);
                              })),


                      CupertinoFormRow(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                        prefix: const Text("Port "),
                        child: MacosTextField(
                                controller: proxyServerPort,
                                keyboardType: TextInputType.number,
                                // prefix: Text("Server IP"),
                                onChanged: (value) {
                                  box.put("proxy_server_port", int.tryParse(value));
                                },
                              )
                            
                      ),
                    ],
                  );
                })),

        //proxy server port
        //list connected clients


        //network info 
        const NetworkInfoListSection()
      ],
    );
  }
}

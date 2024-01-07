import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/server_proxy/client.dart';
import 'package:stagecon/server_proxy/proxy_controller.dart';

class ProxyActivityIndicator extends StatefulWidget {
  const ProxyActivityIndicator({super.key});

  @override
  State<ProxyActivityIndicator> createState() => _ProxyActivityIndicatorState();
}

class _ProxyActivityIndicatorState extends State<ProxyActivityIndicator> {
  ProxyController proxyController = Get.find();

  //server state

  Widget _buildClientIndicator(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: proxyController.client.status,
        builder: (context, value, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: switch(value) {
                      ScProxyClientStatus.disconnected => CupertinoColors.systemRed,
                      ScProxyClientStatus.reconnecting => CupertinoColors.systemOrange,
                      ScProxyClientStatus.connected => CupertinoColors.systemGreen,
                    },
                    borderRadius: BorderRadius.circular(100)),
              ),
              const SizedBox(width: 4),
              switch(value) {
                ScProxyClientStatus.disconnected => const Text("Disconnected",),
                ScProxyClientStatus.reconnecting => const Text("Reconnecting",),
                ScProxyClientStatus.connected => const Text("Connected",),
              },
            ],
          );
        });
  }

  Widget _buildServerIndicator(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: proxyController.server.isServing,
        builder: (context, isServing, child) {
          if (!isServing) {
            return const Text("Server Stopped");
          }
          return ValueListenableBuilder(
              valueListenable: proxyController.server.sockets,
              builder: (context, clients, child) {
                return Text("${clients.length} ${clients.length == 1?"Client":"Clients"}");
                // return Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Container(
                //       width: 8,
                //       height: 8,
                //       decoration: BoxDecoration(
                //           color: value ? CupertinoColors.systemGreen : CupertinoColors.systemRed,
                //           borderRadius: BorderRadius.circular(100)),
                //     ),
                //     const SizedBox(width: 4),
                //     Text("${value.length} clients")
                //   ],
                // );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    // if(proxyController.client == null && proxyController.server == null) {
    //   return const SizedBox();
    // }

    return DefaultTextStyle(
        style: MacosTheme.of(context).typography.body,
        child: ValueListenableBuilder(
            valueListenable: Hive.box("preferences").listenable(keys: ["proxy_server_enabled", "proxy_client_enabled"]),
            builder: (context, box, child) {
              var serverEnabled = box.get("proxy_server_enabled", defaultValue: false);
              var clientEnabled = box.get("proxy_client_enabled", defaultValue: false);
              if (!serverEnabled && !clientEnabled) {
                return const SizedBox();
              }

              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5.resolveFrom(context), borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //client indicator
                      if (clientEnabled) _buildClientIndicator(context),
                      if (clientEnabled && serverEnabled)
                        const SizedBox(
                          width: 10,
                          child: Text("/"),
                        ),
                      if (serverEnabled) _buildServerIndicator(context),
                    ],
                  ));
            }));
  }
}

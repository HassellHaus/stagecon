import 'dart:io';

// import 'package:cupertino_lists/cupertino_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_install_app_plugin/flutter_install_app_plugin.dart';
// import 'package:open_store/open_store.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';


class OtherApps extends StatelessWidget {
  const OtherApps({super.key});




  Widget app({required String title, required String imagePath, int? appStoreId, String? playStoreId}) {
    if(appStoreId == null && Platform.isIOS) {
      return const SizedBox();
    }
    if(playStoreId == null && Platform.isAndroid) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        var app = AppSet()
          ..iosAppId = appStoreId
          ..iosCampaignToken = "Recommended Apps"
          ..androidPackageName = playStoreId;
        FlutterInstallAppPlugin.installApp(app);
        // OpenStore.instance.open(
        //   appStoreId: appStoreId, // AppStore id of your app for iOS
        //   // appStoreIdMacOS: '284815942', // AppStore id of your app for MacOS (appStoreId used as default)
        //   androidAppBundleId: playStoreId, // Android app bundle package name
        //   // windowsProductId: '9NZTWSQNTD0S' // Microsoft store id for Widnows apps
        // );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    //tmp
    // if(!Platform.isIOS) {
    //   return const SizedBox();
    // }
    
    return CupertinoListSection.insetGrouped(
      header: const Text("Recommended Apps"),
      children: [
        // CupertinoListTile.notched(title: title)
        Padding(padding: const EdgeInsets.all(10), 
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
            app(title: "PassBag", imagePath: "assets/apps/passbag.png", appStoreId: 1616677536),
          ]),
        )
      ],
    );
  }
}
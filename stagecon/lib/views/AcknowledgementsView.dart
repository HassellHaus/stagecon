import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:convert';


//convert the above widget to a stateless widget 
class AcknowledgementsView extends StatelessWidget {
  const AcknowledgementsView({
    Key ? key
  }): super(key: key);

    Future<List<Map<String, dynamic>>> getAcknowledgements() async {
    final String response = await rootBundle.loadString('assets/Acknowledgements.json');
    // print(response);
    List<dynamic> list = jsonDecode(response);
    List<Map<String, dynamic>> ackList = [];
    for(var item in list) {
      ackList.add(item as Map<String, dynamic>);
    }
    // jsonDecode(response);
    return ackList;

  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Settings',
        middle: Text("Acknowledgements"),

      ),
      
      child: FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(snapshot.connectionState == ConnectionState.done) {
        List<Map<String, dynamic>> ackList = snapshot.data;

        return ListView.builder(
          itemBuilder: (context, index) {
            return _AckItem(
              head: ackList[index]['name'],
              license: ackList[index]['license'],
              subHead: ackList[index]['version'],
            );
          }, itemCount: ackList.length
        );
      }

      return const Center(child: CupertinoActivityIndicator());
      

    }, future: getAcknowledgements()));
  }
}


class _AckItem extends StatelessWidget {
  const _AckItem({
    Key ? key,
    required this.head,
    this.license,
    this.subHead
  }): super(key: key);

  final String head;
  final String? license;
  final String? subHead;

  @override
  Widget build(BuildContext context) {
    String? subHead = this.subHead;
    if(subHead != null ) {
      if(subHead.length < 40) {
        subHead = subHead;
      } else {
        subHead = '${subHead.substring(0, 40)}...';
      }
    } else if(license != null) {
      if(license!.length < 40) {
        subHead = license;
      } else {
        subHead = '${license!.substring(0, 40)}...';
      }
    }
    // String? _subHead = subHead !=null? subHead!.substring(0, 40) + "..." :  (license != null ? license!.substring(0, 40) + "..." : null);
    return CupertinoListTile.notched(
      title: Text(head), 
      trailing: const CupertinoListTileChevron()  ,
      subtitle: (subHead!= null)?Text(subHead):null, 
      onTap: () {
        //showCupertinoModalBottomSheet(context: context, builder: (_) => _AckItemLicensePopup(head: head, license: license));
        //Get.to(()=> _AckItemLicensePopup(head: head, license: license, subHead: subHead,));
        Navigator.push(
          context,
          CupertinoPageRoute(fullscreenDialog: false, builder: (context) => _AckItemLicensePopup(head: head, license: license, subHead: subHead,)),
        );
      }
    );
  }
}


class _AckItemLicensePopup extends StatelessWidget {
  const _AckItemLicensePopup({
    Key ? key,
    required this.head,
    this.license,
    this.subHead
  }): super(key: key);

  final String head;
  final String ? license;
  final String? subHead;

  @override
  Widget build(BuildContext context) {
    // if(subHead) {}
    return DefaultTextStyle(style: CupertinoTheme.of(context).textTheme.textStyle, child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Acknowledgements",
        middle: Text(head),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 130.0),
          child: Column(
            children: [
              Text(subHead ?? "", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),),
              Text(license ?? ""),
            ])
            
        ),
      ),
    ));
  }
}
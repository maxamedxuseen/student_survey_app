import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class OCMs extends StatefulWidget {
  const OCMs({super.key});

  @override
  State<OCMs> createState() => _OCMsState();
}

class _OCMsState extends State<OCMs> {
  bool isconnected = true;
  Future<void> checkconn() async {
    var connectivity = await (Connectivity().checkConnectivity());
    setState(() {
      isconnected = (connectivity != ConnectivityResult.none);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkconn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
        title: Text("OCMs"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ])),
        ),
      ),
      body: isconnected
          ? Container(
              // margin: EdgeInsets.only(top: 80),
              child: WebView(
                initialUrl: 'https://ocms.simad.edu.so/',
                javascriptMode: JavascriptMode.unrestricted,
              ),
            )
          : Container(
              color: Colors.amber,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi,
                      size: 48,
                    ),
                    Text(
                      'Not connected',
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

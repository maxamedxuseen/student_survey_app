import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'getways.dart';

class AnnouncmentPage extends StatefulWidget {
  const AnnouncmentPage({super.key});

  @override
  State<AnnouncmentPage> createState() => _AnnouncmentPageState();
}

var Anounce = Gateways().AnouncmentURL.toString();
var _mainData = [];
Future<List> _getData() async {
  _mainData = [];
  var date = await get((Uri.parse(Anounce)));
  var jasonData = jsonDecode(date.body);
  for (var u in jasonData) {
    _mainData.add(u);
  }

  return _mainData;
}

class _AnnouncmentPageState extends State<AnnouncmentPage> {
  @override
  Widget build(BuildContext context) {
    print(_mainData);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Announcments"),
      // ),
      body: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
                itemCount: _mainData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/imgs/simad.png"),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            _mainData[index]["title"],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Times New Roman",
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 25, right: 15, bottom: 15, top: 8),
                        child: Column(
                          children: [
                            Text(_mainData[index]["text"]),
                            SizedBox(
                              height: 10,
                            ),
                            Image(
                                image: NetworkImage(_mainData[index]["image"]))
                          ],
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).primaryColor,
                        height: 1,
                      )
                    ],
                  );
                });
          }),
    );
  }
}

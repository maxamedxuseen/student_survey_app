import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:student_survey_app/SurveyNames.dart';
import 'package:student_survey_app/getways.dart';

class surveyTime extends StatefulWidget {
  const surveyTime({super.key});

  @override
  State<surveyTime> createState() => _surveyTimeState();
}

class _surveyTimeState extends State<surveyTime> {
  var surveyTime = Gateways().SurveyTimeURL.toString();
  var _mainData = [];
  var current = DateTime.now();

  // Future<List> _getData() async {
  //   _mainData = [];
  //   var date = await get(Uri.parse(surveyTime));
  //   var jsonData = jsonDecode(date.body);
  //   var now = DateTime.now();

  //   var availableSurveys = [];
  //   var upcomingSurveys = [];

  //   for (var u in jsonData) {
  //     var startingDate = DateTime.parse(u["starting_date"]);
  //     var deadlineDate = DateTime.parse(u["end_date"]);

  //     if (startingDate.isAfter(now)) {
  //       _mainData.add(u);
  //     }
  //   }
  //   return _mainData;
  // }
  Future<List> _getData() async {
    _mainData = [];
    var date = await get(Uri.parse(surveyTime));
    var jsonData = jsonDecode(date.body);
    var now = DateTime.now();

    for (var u in jsonData) {
      var staringDate = DateTime.parse(u["staring_date"]);
      var deadlineDate = DateTime.parse(u["end_date"]);
      var currentDate = DateTime.now();
      var later = currentDate.add(Duration(days: 5));
      var Before = later.add(Duration(days: 5));

      if (!staringDate.isAfter(currentDate) &&
          !deadlineDate.isBefore(currentDate)) {
        _mainData.add(u);
      }
    }
    print(_mainData);

    return _mainData;
  }

  @override
  void initState() {
    super.initState();
    _mainData = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text("surveyTime"),
          centerTitle: true,
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).primaryColor,
                ])),
          ),
        ),
        body: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (_mainData.isEmpty || _mainData == []) {
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/imgs/security-research.gif"),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "The surveys will comming soon",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: _mainData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 785,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).primaryColor
                        ],
                        begin: const FractionalOffset(0, 0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Center(
                      child: _mainData.isEmpty
                          ? Center(
                              child: Text(
                                "Coming Soon \n \n",
                                style: const TextStyle(fontSize: 35),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Welcome to the Survey \n ${_mainData[index]["year_name"]}",
                                  style: GoogleFonts.indieFlower(
                                    color: Color.fromARGB(255, 42, 42, 42),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SurveyNames(
                                                  _mainData[index]["id"]),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      size: 35,
                                    ))
                              ],
                            ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}

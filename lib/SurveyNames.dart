import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:student_survey_app/getways.dart';
import 'package:student_survey_app/registartion_Alumni.dart';
import 'EachSurveyQua.dart';

class SurveyNames extends StatefulWidget {
  int id;
  SurveyNames(this.id);
  @override
  _SurveyNamesState createState() => _SurveyNamesState();
}

class _SurveyNamesState extends State<SurveyNames> {
  var surveys = Gateways().SurveyURL.toString();
  var _mainData = [];

  Future<List> _getData() async {
    var speSurveys = surveys + "${widget.id}";

    _mainData = [];
    var date = await get(Uri.parse(speSurveys));
    var jsonData = jsonDecode(date.body);
    for (var u in jsonData) {
      _mainData.add(u);
    }

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
        title: Text("Surveys"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(child: Text('Register')),
                      content: Text('Please register for being part of alumni'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegistarionAlumni())),
                              child: Text('Register'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.verified,
                color: Colors.lightGreen,
              ))
        ],
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
      body: WillPopScope(
        onWillPop: () async {
          // Return `false` to disable the back button press
          return true;
        },
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: _mainData.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (_mainData[index]["status"] == "In active") {
                      return Center(
                        child: Image.asset("assets/imgs/"),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApplicationPage(
                                  _mainData[index]["id"],
                                  _mainData[index]["survey_name"],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFA9E4A9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _mainData[index]["survey_name"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
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
                          "The surviesn will comming soon",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_survey_app/getways.dart';
import 'package:student_survey_app/widgets/header_widget.dart';

class AlumniProfile extends StatefulWidget {
  const AlumniProfile({super.key});

  @override
  State<AlumniProfile> createState() => _AlumniProfileState();
}

class _AlumniProfileState extends State<AlumniProfile> {
  var _mainDatas = [];
  var _mainData = [];
  var _founditem = [];
  var allAlumni = Gateways().alumniURL.toString();
  var SingalAlumni = Gateways().alumniLogURL.toString();

  int? sid;
  String? sname;
  String? sEnd;
  String? sphone;
  String? sgender;
  String? suuId;
  String? spass;
  String? sfacl;
  String? sdate;

  Future<List> _getData() async {
    _mainDatas = [];
    var date = await get((Uri.parse(allAlumni)));
    var jasonData = jsonDecode(date.body);
    for (var a in jasonData) {
      _mainDatas.add(a);
    }

    return List.from(jasonData);
  }

  String getYearFromDateString(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return date.year.toString();
  }

  Future<List> _getDataSingle() async {
    _mainData = [];
    final prefs = await SharedPreferences.getInstance();
    prefs.getBool("isLoggedIn");
    String? cname = prefs.getString("sname");
    String? cuuId = prefs.getString("uni_ids");
    String? cfacl = prefs.getString("fclt");
    String? cdate = prefs.getString("date");

    var all = SingalAlumni + "${cuuId}";

    var date = await get((Uri.parse(all)));
    var jasonData = jsonDecode(date.body);
    for (var u in jasonData) {
      var Birthda = DateTime.parse(u["Date_birth"]);
      var later = Birthda.add(Duration(days: 2));
      var formattedDate = DateFormat('yyyy-MM-dd').format(later);
      sname = u["name"];
      suuId = u["alu_id"];
      sphone = u["Phone"];
      sfacl = u["faculty_name"];
      sgender = u["Gender"];
      sdate = formattedDate;
      _mainData.add(u);
    }

    // print(all);
    return _mainData;
  }

  void _runFilter(String enterKeyWord) {
    var result = [];
    if (enterKeyWord.isEmpty) {
      result = _mainDatas;
    } else {
      result = _mainDatas
          .where((element) => element["name"]
              .toLowerCase()
              .contains(enterKeyWord.toLowerCase()))
          .toList();
    }

    setState(() {
      _founditem = result;
    });

    print(_founditem);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainData;
    _getData().then((value) {
      setState(() {
        _founditem = _mainDatas;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alumni Profile"),
        centerTitle: true,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 15, color: Colors.white),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: FutureBuilder(
                future: _getDataSingle(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  // print(snapshot.data);
                  // print(suuId);
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 5, color: Colors.white),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(
                                    sname.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Text(
                                        sdate.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      child: Text(
                                        suuId.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Text(
                                sgender.toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              sfacl.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              sphone.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Alumni",
                  style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: _founditem.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(width: 15, color: Colors.white),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        _founditem[index]["name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _founditem[index]["faculty_name"],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        _founditem[index]["Gender"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 1, color: Colors.white),
                          // color: Colors.white,
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Theme.of(context).primaryColor,
                                Theme.of(context).colorScheme.secondary,
                              ]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          getYearFromDateString(_founditem[index]["End_Date"]),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  )
                ],
              );
            },
          ))
        ],
      ),
    );
  }
}

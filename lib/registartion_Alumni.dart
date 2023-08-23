import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
// import 'package:flutter_login_ui/common/theme_helper.dart';
// import 'package:flutter_login_ui/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_survey_app/AlumniProfile.dart';
import 'package:student_survey_app/common/theme_helper.dart';
import 'package:student_survey_app/getways.dart';
import 'package:student_survey_app/mainhome.dart';
import 'package:student_survey_app/surveytime.dart';
import 'package:student_survey_app/widgets/header_widget.dart';

import 'login_page.dart';
// import 'package:hexcolor/hexcolor.dart';

// import 'profile_page.dart';

class RegistarionAlumni extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistarionAlumniState();
  }
}

enum Gender { Male, Female }

class _RegistarionAlumniState extends State<RegistarionAlumni> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  List<dynamic> options = [];
  String? optionsId;
  var _selectedValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // faculty();
    // _datas;
  }

  // double _headerHeight = 250;
  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController StartDateInput = TextEditingController();
  final TextEditingController EndDateInput = TextEditingController();
  String? selectedGender;
  // bool checkedValue = false;
  // bool checkboxValue = false;
  String txtTitle = "";
  String txtDescription = "";
  var PHONE = "";
  var useruuid;
  var NAME;
  var email;
  var phone;
  var username;
  var uuid;
  var PASSWORD;
  var status;
  var _datas = [];
  var facultys = Gateways().facultyURL.toString();
  Future<List> faculty() async {
    final response = await get((Uri.parse(facultys)));
    final students = jsonDecode(response.body);
    for (var rec in students) {
      _datas.add(rec);
    }
    print(_datas);
    return _datas;
  }

  Future<bool> _addnewCust() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getBool("isLoggedIn");
    String? cname = prefs.getString("sname");
    String? cuuId = prefs.getString("uni_ids");
    String? cfacl = prefs.getString("fclt");
    String? cdate = prefs.getString("date");

    var NAME = cname;
    var uniID = cuuId;
    var alumniId = "ALU-${cuuId}";
    var phone = _phone.text;
    var birthDate = cdate;
    var facultyname = cfacl;
    var startDate = StartDateInput.text;
    var EndDate = EndDateInput.text;
    var gender = selectedGender.toString();

    var body = {
      "name": NAME,
      "alu_id": alumniId,
      "univ_id": uniID,
      "Date_birth": birthDate,
      "faculty_name": facultyname,
      "beging_date": startDate,
      "End_Date": EndDate,
      "Gender": gender,
      "Phone": phone,
    };

    // final response = await get((Uri.parse(checking)));
    // final studentre = jsonDecode(response.body);
    // print(studentre);
    // if (response.statusCode == 200) {
    //   txtTitle = "Registration Successful";
    //   txtDescription = "The ID Number already exists";
    //   _showMyDialog(txtTitle, txtDescription);
    //   return false;
    // } else {
    //       }
    var sign = Gateways().alumniURL.toString();

    var signResponse = await post(Uri.parse(sign), body: body);
    var signData = jsonDecode(signResponse.body);
    print(signData);
    if (signResponse.statusCode == 200) {
      final newPref = await SharedPreferences.getInstance();

      newPref.setBool("isLogged", true);
      newPref.setString("alumnI", signData["alu_id"].toString());
      newPref.setString("sname", signData["name"]);
      newPref.setString("sID", signData["id"].toString());
      newPref.setString("phone", signData["Phone"].toString());
      newPref.setString("startD", signData["beging_date"].toString());
      newPref.setString("EndD", signData["End_Date"].toString());
      newPref.setString("Gend", signData["Gender"].toString());
      newPref.setString("fclt", signData["faculty_name"].toString());
      newPref.setString("date", signData["Date_birth"].toString());

      // ----------------------------------
      int? sid = int.parse(newPref.getString("alumnI")!);
      String? sname = newPref.getString("sname");
      String? semail = newPref.getString("Gend");
      String? sphone = newPref.getString("phone");
      String? suser = newPref.getString("startD");
      String? suuId = newPref.getString("uni_ids");
      String? spass = newPref.getString("EndD");
      String? sfacl = newPref.getString("fclt");
      String? sdate = newPref.getString("date");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('is_registered', true);
      txtTitle = "Registration Successful";
      txtDescription = "Registration Successful";
      _showMyDialogSuc(txtTitle, txtDescription);
      return true;
    } else {
      txtTitle = "Registration Invalid";
      txtDescription = "Make sure your information is unique";
      _showMyDialog(txtTitle, txtDescription);
      return false;
    }
  }

  Future<void> _showMyDialogSuc(String titel, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("${txtTitle}"),
          title: Center(
              child: Icon(
            Icons.verified,
            size: 50,
            color: Colors.green,
          )),
          // iconColor: Colors.green,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                  "${txtDescription}.",
                  style: TextStyle(fontSize: 15),
                )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => surveyTime()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(String titel, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("${txtTitle}"),
          title: Center(
              child: Icon(
            Icons.cancel_outlined,
            size: 50,
            color: Colors.red,
          )),
          // iconColor: Colors.green,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                  "${txtDescription}.",
                  style: TextStyle(fontSize: 15),
                )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  var data = [];

  // void gatdate() async {
  //   try {
  //     final response = await get((Uri.parse(sign)));
  //     final datalist = jsonDecode(response.body) as List;

  //     data = datalist;
  //     // setState(() {
  //     //   _data = datalist;
  //     // });
  //   } catch (err) {}
  //   // print(_data);
  // }

  // void uuidgen() {
  //   gatdate();
  //   // var thisData = customer[""]
  //   // print(_data);
  //   var last = _data[_data.length - 1];
  //   var lastUuid = last["uuid"];
  //   useruuid = (lastUuid + 1);
  //   print(useruuid);
  // }

  @override
  Widget build(BuildContext context) {
    var datas = _datas.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          // Return `false` to disable the back button press
          return true;
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 150,
                child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 5, color: Colors.white),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                        offset: const Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/imgs/simad.png"),
                                    radius: 50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: TextFormField(
                              controller: _phone,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Phone Number', 'Enter your Phone number'),
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: StartDateInput,
                              // decoration: InputDecoration(
                              //     icon: Icon(Icons
                              //         .calendar_today), //icon of text field
                              //     labelText:
                              //         "Enter Date" //label text of field
                              //     ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    StartDateInput.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {}
                              },
                              obscureText: true,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter university starting date";
                                }
                              },
                              decoration: InputDecoration(
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText:
                                      "Enter University Starting Date" //label text of field
                                  ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextFormField(
                              controller: EndDateInput,
                              // decoration: InputDecoration(
                              //     icon: Icon(Icons
                              //         .calendar_today), //icon of text field
                              //     labelText:
                              //         "Enter Date" //label text of field
                              //     ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    EndDateInput.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {}
                              },
                              obscureText: true,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter university End date";
                                }
                              },
                              decoration: InputDecoration(
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText:
                                      "Enter University End Date" //label text of field
                                  ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            child: Column(
                              children: [
                                // Male checkbox
                                CheckboxListTile(
                                  title: Text('Male'),
                                  value: selectedGender == 'Male',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectedGender = value! ? 'Male' : null;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                // Female checkbox
                                CheckboxListTile(
                                  title: Text('Female'),
                                  value: selectedGender == 'Female',
                                  onChanged: (bool? value) {
                                    setState(() {
                                      selectedGender = value! ? 'Female' : null;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ],
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Register".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _addnewCust();

                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //     MaterialPageRoute(
                                  //         builder: (context) => MainHomePage()),
                                  //     (Route<dynamic> route) => false);
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Text(
                            "Or create account using social media",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: FaIcon(
                                  FontAwesomeIcons.googlePlus,
                                  size: 35,
                                  color: HexColor("#EC2D2F"),
                                ),
                                onTap: () {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ThemeHelper().alartDialog(
                                            "Google Plus",
                                            "You tap on GooglePlus social icon.",
                                            context);
                                      },
                                    );
                                  });
                                },
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 5, color: HexColor("#40ABF0")),
                                    color: HexColor("#40ABF0"),
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.twitter,
                                    size: 23,
                                    color: HexColor("#FFFFFF"),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ThemeHelper().alartDialog(
                                            "Twitter",
                                            "You tap on Twitter social icon.",
                                            context);
                                      },
                                    );
                                  });
                                },
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              GestureDetector(
                                child: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 35,
                                  color: HexColor("#3E529C"),
                                ),
                                onTap: () {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ThemeHelper().alartDialog(
                                            "Facebook",
                                            "You tap on Facebook social icon.",
                                            context);
                                      },
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
// import 'package:flutter_login_ui/common/theme_helper.dart';
// import 'package:flutter_login_ui/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_survey_app/common/theme_helper.dart';
import 'package:student_survey_app/getways.dart';
import 'package:student_survey_app/widgets/header_widget.dart';

import 'login_page.dart';
// import 'package:hexcolor/hexcolor.dart';

// import 'profile_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
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
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
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
    var NAME = _name.text;
    var email = _email.text;
    var phone = _phone.text.toUpperCase();
    var username = _username.text;
    var PASSWORD = _password.text;
    var status = "Active";
    var faculties = optionsId;

    var body = {
      "name": NAME,
      "email": email,
      "uni_id": phone,
      "username": username,
      "password": PASSWORD,
      "image": "mmmm",
      "status": status,
      "faculty_id": faculties
    };
    var stuUniId = Gateways().customersUniIdURL.toString();
    var checking = stuUniId + phone;

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
    var sign = Gateways().customersURL.toString();

    var signResponse = await post(Uri.parse(sign), body: body);
    var signData = jsonDecode(signResponse.body);
    print(signData);
    if (signResponse.statusCode == 200) {
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
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
      body: SingleChildScrollView(
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
                                  border:
                                      Border.all(width: 5, color: Colors.white),
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
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
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
                            controller: _name,
                            decoration: ThemeHelper().textInputDecoration(
                                'Full Name', 'Enter your first name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _phone,
                            decoration: ThemeHelper().textInputDecoration(
                                'Id Number', 'Enter your ID number'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _email,
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _username,
                            decoration: ThemeHelper().textInputDecoration(
                                "Username", "Enter your username"),
                            keyboardType: TextInputType.visiblePassword,
                            // validator: (val) {
                            //   if (!(val!.isEmpty) &&
                            //       !RegExp(r"^(\d+)*$").hasMatch(val)) {
                            //     return "Enter a valid usernmae";
                            //   }
                            //   return null;
                            // },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),

                        Container(
                          height: 100,
                          child:
                              // FutureBuilder(
                              //   future: faculty(),
                              //   builder: (BuildContext context,
                              //       AsyncSnapshot<dynamic> snapshot) {
                              //     return DropdownButton<int>(
                              //       value: _selectedValue,
                              //       hint: Text('Select an answer'),
                              //       onChanged: (newValue) {
                              //         // _handleAnswerSelection(questionId, newValue!);
                              //         setState(() {
                              //           _selectedValue = newValue!;
                              //         });
                              //       },
                              //       items: _datas.map((facult) {
                              //         // print(_selectedAnswers[questionId]);
                              //         return DropdownMenuItem<int>(
                              //           value: facult['id'],
                              //           child: Text(facult['fcl_Name']),
                              //         );
                              //       }).toList(),
                              //     );
                              //   },
                              // ),

                              FutureBuilder(
                            future: faculty(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return Container(
                                child: FormHelper.dropDownWidgetWithLabel(
                                  context,
                                  "Choose your Faculty ",
                                  "Options",
                                  optionsId,
                                  _datas,
                                  (onValidateval) {
                                    if (onValidateval == null) {
                                      return 'Please Select one option';
                                    }
                                    return null;
                                  },
                                  (onChangeVal) {
                                    optionsId = onChangeVal;
                                    print("Select an option: $onChangeVal");
                                    // return optionsId;
                                  },
                                  borderColor: Colors.blue,
                                  borderFocusColor: Colors.green,
                                  optionLabel: "fcl_Name",
                                  optionValue: "id",
                                ),
                              );
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),

                        // SizedBox(height: 20.0),
                        // SizedBox(height: 15.0),
                        // FormField<bool>(
                        //   builder: (state) {
                        //     return Column(
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             Checkbox(
                        //                 value: checkboxValue,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     checkboxValue = value!;
                        //                     state.didChange(value);
                        //                   });
                        //                 }),
                        //             Text(
                        //               "I accept all terms and conditions.",
                        //               style: TextStyle(color: Colors.grey),
                        //             ),
                        //           ],
                        //         ),
                        //         Container(
                        //           alignment: Alignment.centerLeft,
                        //           child: Text(
                        //             state.errorText ?? '',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(
                        //               color: Theme.of(context).errorColor,
                        //               fontSize: 12,
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     );
                        //   },
                        //   validator: (value) {
                        //     if (!checkboxValue) {
                        //       return 'You need to accept terms and conditions';
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
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
    );
  }
}

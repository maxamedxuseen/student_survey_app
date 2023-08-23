import 'dart:convert';

// import 'package:byteso_maqalbooks/pages/EditProfile.dart';
// import 'package:byteso_maqalbooks/pages/login_page.dart';
// import 'package:byteso_maqalbooks/pages/profile_page.dart';
// import 'package:byteso_maqalbooks/screens/book.dart';
// import 'package:byteso_maqalbooks/screens/books.dart';
// import 'package:byteso_maqalbooks/screens/favorite.dart';
// import 'package:byteso_maqalbooks/screens/home.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_survey_app/AlumniProfile.dart';
import 'package:student_survey_app/Home.dart';
import 'package:student_survey_app/OCMs.dart';
import 'package:student_survey_app/SurveyNames.dart';
import 'package:student_survey_app/announcmentPage.dart';
import 'package:student_survey_app/getways.dart';
import 'package:student_survey_app/login_page.dart';
import 'package:student_survey_app/profilePage.dart';
import 'package:student_survey_app/registartion_Alumni.dart';
import 'package:student_survey_app/surveytime.dart';

// import '../cores/books.dart';
// import '../cores/getways.dart';

class MainHomePage extends StatefulWidget {
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

List Screens = [
  // favoritePage(),

  HomePage(), AnnouncmentPage(),
];
int _page = 0;
// var bookurl = Gateways().booksURL.toString();
// var catagoryUrl = Gateways().catagoryURL.toString();

// var _mainData = [];

// Future<List> _getData() async {
//   _mainData = [];
//   var date = await get((Uri.parse(bookurl)));
//   var jasonData = jsonDecode(date.body);
//   for (var u in jasonData) {
//     _mainData.add(u);
//   }

//   return _mainData;
// }

// var newData = [];
// Future<List> getlatest() async {
//   newData = [];
//   var date = await get((Uri.parse(bookurl + "leatest/")));
//   print(bookurl);
//   var jasonData = jsonDecode(date.body);
//   for (var u in jasonData) {
//     newData.add(u);
//   }

//   return newData;
// }

// var Catagories = [];
// Future<List> getCatagory() async {
//   Catagories = [];
//   var date = await get((Uri.parse(catagoryUrl)));
//   var jasonData = jsonDecode(date.body);
//   for (var u in jasonData) {
//     Catagories.add(u);
//   }
//   // print(Catagories);
//   currentPage = 1;

//   return Catagories;
// }

int currentPage = 0;
double _drawerIconSize = 24;
double _drawerFontSize = 17;

class _MainHomePageState extends State<MainHomePage> {
  var surveyTimes = Gateways().SurveyTimeURL.toString();
  var _mainDatas = [];
  var SingalAlumni = Gateways().alumniLogURL.toString();
  Future<List> _getData() async {
    _mainDatas = [];
    var date = await get(Uri.parse(surveyTimes));
    var jsonData = jsonDecode(date.body);
    var now = DateTime.now();

    for (var u in jsonData) {
      var staringDate = DateTime.parse(u["staring_date"]);
      var deadlineDate = DateTime.parse(u["end_date"]);
      var currentDate = DateTime.now();
      var later = currentDate.add(Duration(days: 5));
      var Before = later.add(Duration(days: 5));

      if (!staringDate.isAfter(currentDate) &&
          deadlineDate.isBefore(currentDate)) {
        _mainDatas.add(u);
      }
    }
    // print(later);

    return _mainDatas;
  }

  var _mainData = [];
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
      _mainData.add(u);
    }

    // print(all);
    return _mainData;
  }

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // TODO: implement initState
    super.initState();
    // print(catagoryUrl);
    // getCatagory();
    // getlatest();
    // _getData();
    _mainData;
    _mainDatas;
    currentPage = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPopup(); // Show the pop-up after the first frame is built
    });
  }

  late int cid;
  String? cname;
  String? cemail;
  String? cphone;
  String? cuser;
  String? cuuId;
  String? cpass;
  String? cfacl;
  String? cdate;

  Future<void> _showPopup() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getBool("isLoggedIn");
    cid = int.parse(prefs.getString("sID")!);
    cname = prefs.getString("sname");
    cemail = prefs.getString("email");
    cphone = prefs.getString("image");
    cuser = prefs.getString("username");
    cuuId = prefs.getString("uni_ids");
    cpass = prefs.getString("password");
    cfacl = prefs.getString("fclt");
    cdate = prefs.getString("date");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(cname!, cemail!, cfacl!);
      },
    );
  }

  pushing() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AnnouncmentPage()));
  }

  triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basicChannel',
        title: 'Simple Notification',
        body: 'Simple Button',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.secondary,
                  ])),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              color: Colors.black,
              icon: Icon(Icons.bar_chart_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          "Students Survey",
          style: GoogleFonts.indieFlower(
            color: Color.fromARGB(255, 42, 42, 42),
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //       color: Colors.black,
        //       onPressed: pushing,
        //       icon: Icon(Icons.notifications))
        // ],
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(20),
        //         bottomRight: Radius.circular(20)),
        //     gradient: LinearGradient(colors: [
        //       Theme.of(context).primaryColor.withOpacity(0.2),
        //       Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        //     ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        //   ),
        // ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                0.0,
                1.0
              ],
                  colors: [
                Theme.of(context).primaryColor.withOpacity(0.2),
                Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ])),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      child:
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            cname.toString(),
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            cemail.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.verified_user_sharp,
                  size: _drawerIconSize,
                  color: Colors.black,
                  // color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Profile Page',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Colors.black,
                    // color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                            cname.toString(),
                            cemail.toString(),
                            cuuId.toString(),
                            cuser.toString(),
                            cfacl.toString())),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              FutureBuilder(
                  future: _getDataSingle(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    print(snapshot.data);
                    return ListTile(
                      leading: Icon(
                        Icons.question_answer,
                        size: _drawerIconSize,
                        color: Colors.black,
                        // color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        'Survey',
                        style: TextStyle(
                          fontSize: _drawerFontSize,
                          color: Colors.black,
                          // color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                      onTap: () {
                        if (_mainData.isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistarionAlumni()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => surveyTime()),
                          );
                        }
                      },
                    );
                  }),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              FutureBuilder(
                  future: _getDataSingle(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    print(snapshot.data);
                    return ListTile(
                      leading: Icon(
                        Icons.person,
                        size: _drawerIconSize,
                        color: Colors.black,
                        // color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        'Alumni profile',
                        style: TextStyle(
                          fontSize: _drawerFontSize,
                          color: Colors.black,
                          // color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                      trailing: _mainData.isEmpty
                          ? Icon(Icons.lock)
                          : Icon(Icons.verified),
                      onTap: () {
                        if (_mainData.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Survey Required'),
                                content: Text(
                                    'Please complete the registration to access this feature.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Show a message to the user or redirect to the registration page
                          // to prompt them to complete the registration process.
                          // For example:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlumniProfile()),
                          );
                        }
                      },
                    );
                  }),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.supervised_user_circle,
                  size: _drawerIconSize,
                  color: Colors.black,
                  // color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'OCMs',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Colors.black,
                    // color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OCMs()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: _drawerIconSize,
                  // color: Theme.of(context).colorScheme.secondary,
                  color: Colors.black,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: _drawerFontSize,
                    // color: Theme.of(context).colorScheme.secondary
                    color: Colors.black,
                  ),
                ),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("isLoggedIn", false);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 227, 229, 230),
        currentIndex: _page,
        onTap: (int index) {
          setState(() {
            _page = index;
          });
        },
        items: const [
          // BottomNavigationBarItem(
          //   label: "Favorite",
          //   icon: Icon(
          //     Icons.favorite,
          //   ),
          // ),
          BottomNavigationBarItem(
            label: "home",
            icon: Icon(Icons.home),
          ),

          BottomNavigationBarItem(
            label: "Anouncment",
            icon: Icon(Icons.chat_bubble),
          ),
        ],
      ),
      body: Screens[_page],
    );
  }
}

class CustomPopup extends StatefulWidget {
  // int id;
  String name;
  String email;
  String faculty;

  CustomPopup(this.name, this.email, this.faculty);

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.handshake,
        size: 55,
      ),
      iconColor: Colors.green,
      title: Column(
        children: [
          Text(
            'Welcome',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.name,
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      content: Text(
        'Thank you for your participating I hope you will enjoy.',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Welcome'),
        ),
      ],
    );
  }
}

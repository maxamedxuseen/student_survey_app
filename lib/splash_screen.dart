import 'dart:async';

// import 'package:byteso_maqalbooks/home.dart';
// import 'package:byteso_maqalbooks/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:student_survey_app/login_page.dart';
// import 'package:trying/home.dart';
// import 'package:trying/login_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var cid1 = 0;
  var cname1;
  var cemail1;
  var cphone1;
  var cuser1;
  var cuuId1;
  var cpass1;
  var isLogged = false;

  bool _isVisible = false;
  // void check() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   isLogged = prefs.getBool('isLoggedIn') ?? false;

  //   if (isLogged) {
  //     int cid = int.parse(prefs.getString("cID")!);
  //     String? cname = prefs.getString("cname");
  //     String? cemail = prefs.getString("email");
  //     String? cphone = prefs.getString("phone");
  //     String? cuser = prefs.getString("username");
  //     String? cuuId = prefs.getString("uuid");
  //     String? cpass = prefs.getString("password");

  //     cid1 = cid;
  //     cname1 = cname;
  //     cemail1 = cemail;
  //     cphone1 = cphone;
  //     cuser1 = cuser;
  //     cuuId1 = cuuId;
  //     cpass1 = cpass;
  //   }
  // }

  _SplashScreenState() {
    new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    });

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // check();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
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
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 200.0,
            width: 200.0,
            child: Center(
                child: Image(
              image: AssetImage("assets/imgs/simad.png"),
              // width: 150,
              // height: 150,
            )
                // ClipOval(
                //   child: Icon(
                //     Icons.headphones_outlined,
                //     size: 128,
                //   ), //put your logo here
                // ),
                ),
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.3),
            //         blurRadius: 2.0,
            //         offset: Offset(5.0, 3.0),
            //         spreadRadius: 2.0,
            //       )
            //     ]
            //     ),
          ),
        ),
      ),
    );
  }
}

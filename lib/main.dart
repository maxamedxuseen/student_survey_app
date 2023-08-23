import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:student_survey_app/splash_screen.dart';

void main() {
  runApp(const MyApp());
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'basicChannel',
            channelName: 'Basic notifactions',
            channelDescription: 'Notifaction channel for basic test')
      ],
      debug: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: SplashScreen(
        title: 'hello',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

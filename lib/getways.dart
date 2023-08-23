class Gateways {
  static final Gateways _instance = Gateways._internal(
    domains: "http://192.168.1.15:",
    port: "2000/api",
  );

  String domains;
  String port;

  factory Gateways() {
    return _instance;
  }

  Gateways._internal({required this.domains, required this.port});

  String get alumniURL => "$domains$port/alumni/";
  String get alumniLogURL => "$domains$port/alumni/login/";
  String get catagoryURL => "$domains$port/catagory/";
  String get facultyURL => "$domains$port/faculty/";
  String get customerLoginURL => "$domains$port/students/login/";
  String get customersURL => "$domains$port/students/";
  String get customersUniIdURL => "$domains$port/students/un_id/";
  String get SurveyURL => "$domains$port/survey/";
  String get SurveyTimeURL => "$domains$port/survey_time/";
  String get questionsURL => "$domains$port/questions/";
  String get perquestionsURL => "$domains$port/questions/n/";
  String get answersURL => "$domains$port/answers/";
  String get feedbackURL => "$domains$port/feedback/";
  String get AnouncmentURL => "$domains$port/anouncment/";
}

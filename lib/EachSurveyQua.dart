import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_survey_app/SurveyNames.dart';
import 'package:student_survey_app/common/theme_helper.dart';
import 'dart:convert';
import 'package:student_survey_app/getways.dart';

class MyApplicationPage extends StatefulWidget {
  var id;
  String name;

  MyApplicationPage(this.id, this.name);

  @override
  _MyApplicationPageState createState() => _MyApplicationPageState();
}

class _MyApplicationPageState extends State<MyApplicationPage> {
  List<dynamic> _questions = [];
  List<dynamic> _answers = [];
  Map<int, int> _selectedAnswers = {};
  Map<int, bool> _isQuestionAnswered = {};

  String txtTitle = "";
  String txtDescription = "";
  bool _isDropdownValid = false;
  var data = [];

  Future<void> _submitAnswers() async {
    // var data = [];
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    int cid = int.parse(prefs.getString("sID")!);
    _selectedAnswers.forEach((questionId, answerId) async {
      Map<String, String?> jsonData = {
        "question_id": questionId.toString(),
        "answer_id": answerId.toString(),
        "student_id": cid.toString()
      }; // Replace with the appropriate student ID

      var all = Gateways().feedbackURL.toString();
      var response = await get(Uri.parse(all));

      if (response.statusCode == 200) {
        var jasonData = jsonDecode(response.body);

        // Check if the data is present in jasonData
        if (jasonData["question_id"] == jsonData["question_id"] &&
            jasonData["answer_id"] == jsonData["answer_id"] &&
            jasonData["student_id"] == jsonData["student_id"]) {
          // Data already exists in jasonData
          _showMyDialog(
              txtTitle = "Sorry", txtDescription = "You submit it already");
          print("Data is already in the database");
        } else {
          // Data doesn't exist in jasonData, so add it to data
          data.add(jsonData);
        }
      } else {
        // Handle the HTTP error if necessary
      }
    });
    // print(data);
    bool success = await _addnewCust();

    if (success) {
      // Handle success case
      Navigator.pop(context);
      print('Success');
      // print(data);
    } else {
      // Handle error case
      print('Failed');
    }
  }

  Future<bool> _addnewCust() async {
    var addQue = Gateways().feedbackURL.toString();
    print(data);
    List<Future<Response>> requests = [];

    for (Map<String, String?> body in data) {
      print(body);
      var request = post(Uri.parse(addQue), body: body);
      requests.add(request);
    }

    var responses = await Future.wait(requests);

    for (var response in responses) {
      var signData = jsonDecode(response.body);
      print(signData);
      if (response.statusCode != 200) {
        return false;
      }
    }

    return true;
  }

  Future<void> _fetchData() async {
    var questions = Gateways().perquestionsURL.toString();
    var answers = Gateways().answersURL.toString();
    String surveyID = questions + "${widget.id}";

    var questionsResponse = await http.get(Uri.parse(surveyID));
    var answersResponse = await http.get(Uri.parse(answers));

    if (questionsResponse.statusCode == 200 &&
        answersResponse.statusCode == 200) {
      var questionsJsonData = jsonDecode(questionsResponse.body);
      var answersJsonData = jsonDecode(answersResponse.body);

      setState(() {
        _questions = questionsJsonData;
        _answers = answersJsonData;
      });
    } else {
      // Handle error cases here
    }
  }

  void _handleAnswerSelection(int questionId, int answerId) {
    setState(() {
      _selectedAnswers[questionId] = answerId;
      _isQuestionAnswered[questionId] = true;
    });
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
                Navigator.pop(context);
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
          title: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${txtTitle}"),
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 25,
              )
            ],
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text("${txtDescription}.")),
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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // print(_answers);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
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

      body: _questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                var question = _questions[index];
                var questionId = question["id"];
                // var answers = _answers[index];
                var answers = _answers.toList();
                // var selectedAnswerId = _selectedAnswers[questionId];
                // print(question);
                // print(answers);
                return Container(
                  margin: EdgeInsets.only(left: 20, top: 15, right: 15),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 200, 241, 200),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index} - ${question['questions']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<int>(
                        value: _selectedAnswers[questionId],
                        hint: Text('Select an answer'),
                        onChanged: (newValue) {
                          _handleAnswerSelection(questionId, newValue!);
                          setState(() {
                            _isQuestionAnswered[questionId] = true;
                          });
                        },
                        items: answers.map((answer) {
                          // print(_selectedAnswers[questionId]);
                          return DropdownMenuItem<int>(
                            value: answer['id'],
                            child: Text(answer['answers']),
                          );
                        }).toList(),
                      ),
                      if (!_isQuestionAnswered.containsKey(questionId))
                        Text(
                          'Please select an answer',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        decoration: ThemeHelper().buttonBoxDecoration(context),
        child: ElevatedButton(
          style: ThemeHelper().buttonStyle(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
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
            // Check if all questions have been answered
            bool allQuestionsAnswered =
                _isQuestionAnswered.values.every((answered) => answered);

            if (allQuestionsAnswered) {
              // sending();
              _submitAnswers();
            } else {
              // Show a dialog or display a message to inform the user
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Incomplete Form'),
                    content:
                        Text('Please answer all questions before submitting.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          // onPressed: () {

          //     _submitAnswers();

          // },
        ),
      ),

      // FloatingActionButton(
      //   onPressed: () {
      //     // Check if all questions have been answered
      //     bool allQuestionsAnswered =
      //         _isQuestionAnswered.values.every((answered) => answered);

      //     if (allQuestionsAnswered) {
      //       // sending();
      //       _submitAnswers();
      //     } else {
      //       // Show a dialog or display a message to inform the user
      //       showDialog(
      //         context: context,
      //         builder: (context) {
      //           return AlertDialog(
      //             title: Text('Incomplete Form'),
      //             content:
      //                 Text('Please answer all questions before submitting.'),
      //             actions: [
      //               TextButton(
      //                 onPressed: () => Navigator.pop(context),
      //                 child: Text('OK'),
      //               ),
      //             ],
      //           );
      //         },
      //       );
      //     }
      //   },
      //   child: Icon(Icons.send),
      // ),
    );
  }
}

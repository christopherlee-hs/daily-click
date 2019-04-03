import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'word_day_previous.dart';

// TODO: add archive of previous words

Future<Post> fetchWordPost() async {
  final response = await http.get('https://chrisunjae.github.io/daily-click/json/word_day.json');
  if (response.statusCode == 200) { // server returns ok response
    return Post.fromJson(json.decode(response.body));
  }
  else { // not ok
    throw Exception('Failed to load post');
  }
}

var now = new DateTime.now();
String today = now.year.toString() + ' ' + now.month.toString() + ' ' + String.fromCharCode(now.day + 64);
var prev = new DateTime(now.year, now.month, now.day - 1);
String yesterday = prev.year.toString() + ' ' + prev.month.toString() + ' ' + String.fromCharCode(prev.day + 64);

class Post {
  final List<String> todayWordData;
  final List<String> yesWordData;

  Post({this.todayWordData, this.yesWordData});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      todayWordData: new List<String>.from(json[today]),
      yesWordData: new List<String>.from(json[yesterday]),
    );
  }
}

class WordWidget extends StatelessWidget {
  final Future<Post> post;

  WordWidget({Key key, this.post}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word of the Day'),
        backgroundColor: Colors.pink,
      ),
      body: new ListView(
        children: [
          FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    new Row( // today date
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0, bottom: 4.0),
                            child: new Text(
                              "Word " + now.month.toString() + "/" + now.day.toString() + "/" + now.year.toString() + ":",
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    new Row( // today word
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 0, right: 32.0, bottom: 4.0),
                            child: new Text(
                              snapshot.data.todayWordData[0].toLowerCase(),
                              style: new TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    new Row( // today pos & def
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 0, right: 32.0, bottom: 8.0),
                            child: new RichText(
                              text: TextSpan(
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: snapshot.data.todayWordData[1] + ". ", 
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapshot.data.todayWordData[2],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    new Row( // yesterday date
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0, bottom: 4.0),
                            child: new Text(
                              "Yesterday\'s word:",
                              style: new TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    new Row( // yesterday word
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 0, right: 32.0, bottom: 4.0),
                            child: new Text(
                              snapshot.data.yesWordData[0].toLowerCase(),
                              style: new TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    new Row( // yesterday pos & def
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 0, right: 32.0, bottom: 32.0),
                            child: new RichText(
                              text: TextSpan(
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: snapshot.data.yesWordData[1] + ". ", 
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapshot.data.yesWordData[2],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                    new RaisedButton(
                      child: Text(
                        "Archived words",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WordPreviousWidget(post: fetchWordPreviousPost()),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  /*
  State<StatefulWidget> createState() {
    return _WordState();
  }
  */
}
/*
class _WordState extends State<WordWidget> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Word of the Day"),),
    );
  }
}
*/
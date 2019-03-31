import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Post> fetchWordPost() async {
  final response = await http.get('https://chrisunjae.github.io/daily-click/word_day.txt');
  if (response.statusCode == 200) { // server returns ok response
    return Post.fromJson(json.decode(response.body));
  }
  else { // not ok
    throw Exception('Failed to load post');
  }
}

var now = new DateTime.now();
String today = now.year.toString() + ' ' + now.month.toString() + ' ' + now.day.toString();
var prev = new DateTime(now.year, now.month, now.day - 1);
String yesterday = prev.year.toString() + ' ' + prev.month.toString() + ' ' + prev.day.toString();

class Post {
  final String word;
  final String pos;
  final String def;
  final String yesWord;
  final String yesPos;
  final String yesDef;

  Post({this.word, this.pos, this.def, this.yesWord, this.yesPos, this.yesDef});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      word: json[today + ' word'],
      pos: json[today + ' part of speech'],
      def: json[today + ' definition'],
      yesWord: json[yesterday + ' word'],
      yesPos: json[yesterday + ' part of speech'],
      yesDef: json[yesterday + ' definition'],
    );
  }
}

class WordWidget extends StatelessWidget {
  final Future<Post> post;

  WordWidget({Key key, this.post}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word of the Day',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Word of the Day'),
        ),
        body: new ListView(
          children: [
            FutureBuilder<Post>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      new Row(
                        children: [
                          new Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0, bottom: 8.0),
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

                      new Row(
                        children: [
                          new Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(left: 32.0, top: 0, right: 32.0, bottom: 4.0),
                              child: new Text(
                                snapshot.data.word.toLowerCase(),
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

                      new Row(
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
                                      text: snapshot.data.pos + ". ", 
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text: snapshot.data.def,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
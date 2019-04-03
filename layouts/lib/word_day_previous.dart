import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Post> fetchWordPreviousPost() async {
  final response = await http.get('https://chrisunjae.github.io/daily-click/json/word_day.json');
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  }
  else {
    throw Exception('Failed to load post');
  }
}

var today = new DateTime.now();

class Post {
  Map<String, List<dynamic>> wordData;

  Post({this.wordData});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      wordData: new Map<String, List<dynamic>>.from(json),
    );
  }
}

class WordPreviousWidget extends StatelessWidget {
  final Future<Post> post;
  WordPreviousWidget({Key key, this.post});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Previous Words"),
        backgroundColor: Colors.pink,
      ),
      body: new Row(
        children: [
          new Expanded(
            child: FutureBuilder<Post>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: 100,
                    separatorBuilder: (context, position) => Divider(),
                    itemBuilder: (context, position) {
                      var date = new DateTime(today.year, today.month, today.day - position - 2);
                      String sDate = date.year.toString() + ' ' + date.month.toString() + ' ' + String.fromCharCode(date.day + 64);
                      Map<String, List<dynamic>> wordDataMap = snapshot.data.wordData;
                      if (wordDataMap.containsKey(sDate)) {
                        return new Container(
                          child: new Column(
                            children: [
                              new Row(
                                children: [
                                  new Expanded(
                                    child: new Container(
                                      margin: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0, bottom: 4.0),
                                      child: new Text(
                                        date.month.toString() + '/' + date.day.toString() + '/' + date.year.toString(),
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
                                      margin: const EdgeInsets.only(left: 32.0, top: 0.0, right: 32.0, bottom: 4.0),
                                      child: new Text(
                                        wordDataMap[sDate][0].toLowerCase(),
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

                              new Row(
                                children: [
                                  new Expanded(
                                    child: new Container(
                                      margin: const EdgeInsets.only(left: 32.0, top: 0, right: 32.0, bottom: 8.0),
                                      child: new RichText(
                                        text: TextSpan(
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: wordDataMap[sDate][1] + ". ",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            TextSpan(
                                              text: wordDataMap[sDate][2],
                                            ),
                                          ],
                                        ),
                                      )
                                    ),
                                  ),
                                  
                                ],
                              ),
                              
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
                else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }
            ),
          )
        ],
      ),
    );
  }
}

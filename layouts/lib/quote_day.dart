import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quote_day_previous.dart';

// TODO: make code compatible with new format json files (arrays)

Future<Post> fetchQuotePost() async {
  final response = await http.get('https://chrisunjae.github.io/daily-click/quote_day.txt');
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
  final List<String> quoteData;
  final List<String> yesQuoteData;

  Post({this.quoteData, this.yesQuoteData});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      quoteData: new List<String>.from(json[today]),
      yesQuoteData: new List<String>.from(json[yesterday]),
    );
  }
}

class QuoteWidget extends StatelessWidget {

  final Future<Post> post;
  QuoteWidget({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote of the Day'),
        backgroundColor: Colors.red,
      ),
      body: new ListView(
        children: [
          FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    new Row( // today's date
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0, bottom: 8.0),
                            child: new Text(
                              "Quote " + now.month.toString() + "/" + now.day.toString() + "/" + now.year.toString() + ":",
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

                    new Row( // today's quote
                      //margin: const EdgeInsets.all(32.0),
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 0.0, right: 32.0, bottom: 8.0),
                            child: new Text(
                              '\"' + snapshot.data.quoteData[0] + '\"' ?? '',
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

                    new Row( // today's person quoted
                      //margin: const EdgeInsets.all(32.0),
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(right: 32.0),

                            child: new Text(
                              '— ' + snapshot.data.quoteData[1] ?? '',
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            alignment: Alignment(1.0, 0.0),
                          ),
                        ),
                        
                      ],
                    ),

                    new Row( // yesterday
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 43.0, right: 32.0, bottom: 8.0),
                            child: new Text(
                              "Yesterday's quote:",
                              style: new TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    new Row( // yesterday's date
                      //margin: const EdgeInsets.all(32.0),
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(left: 32.0, top: 0.0, right: 32.0, bottom: 4.0),
                            child: new Text(
                              '\"' + snapshot.data.yesQuoteData[0] + '\"' ?? '',
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

                    new Row( // yesterday's person quoted
                      //margin: const EdgeInsets.all(32.0),
                      children: [
                        new Expanded(
                          child: new Container(
                            margin: const EdgeInsets.only(right: 32.0, bottom: 32.0),

                            child: new Text(
                              '— ' + snapshot.data.yesQuoteData[1] ?? '',
                              style: new TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            alignment: Alignment(1.0, 0.0),
                          ),
                        ),
                        
                      ],
                    ),

                    new RaisedButton(
                      child: Text(
                        "Archived quotes",
                        style: new TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuotePreviousWidget(),
                          ),
                        );
                      },
                    ),
                  ],
                );
                
                
                //Text(snapshot.data.quote ?? '');
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ]
      ),
    );
  }
}
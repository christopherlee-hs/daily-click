import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final String quote;
  final String person;
  final String yesQuote;
  final String yesPerson;

  Post({this.quote, this.person, this.yesQuote, this.yesPerson});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      quote: json[today + ' quote'],
      person: json[today + ' person'],
      yesQuote: json[yesterday + ' quote'],
      yesPerson: json[yesterday + ' person'],
    );
  }
}

class QuoteWidget extends StatelessWidget {

  final Future<Post> post;
  QuoteWidget({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quote of the Day'),
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
                              margin: const EdgeInsets.only(left: 32.0, top: 43.0, right: 32.0, bottom: 8.0),
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

                      new Row(
                        //margin: const EdgeInsets.all(32.0),
                        children: [
                          new Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(left: 32.0, top: 0.0, right: 32.0, bottom: 8.0),
                              child: new Text(
                                '\"' + snapshot.data.quote + '\"' ?? '',
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
                        //margin: const EdgeInsets.all(32.0),
                        children: [
                          new Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(right: 32.0),

                              child: new Text(
                                '— ' + snapshot.data.person ?? '',
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

                      new Row(
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

                      new Row(
                        //margin: const EdgeInsets.all(32.0),
                        children: [
                          new Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(left: 32.0, top: 0.0, right: 32.0, bottom: 4.0),
                              child: new Text(
                                '\"' + snapshot.data.yesQuote + '\"' ?? '',
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
                        //margin: const EdgeInsets.all(32.0),
                        children: [
                          new Expanded(
                            child: new Container(
                              margin: const EdgeInsets.only(right: 32.0, top: 0.0),

                              child: new Text(
                                '— ' + snapshot.data.yesPerson ?? '',
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
      ),
    );
  }
}
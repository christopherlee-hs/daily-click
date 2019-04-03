import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Post> fetchQuotePreviousPost() async {
  final response = await http.get('https://chrisunjae.github.io/daily-click/json/quote_day.json');
  if (response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  }
  else {
    throw Exception('Failed to load post');
  }
}

var today = new DateTime.now();

class Post {
  Map<String, List<dynamic>> quoteData;

  Post({this.quoteData});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      quoteData: new Map<String, List<dynamic>>.from(json),
    );
  }
}

class QuotePreviousWidget extends StatelessWidget {
  final Future<Post> post;
  QuotePreviousWidget({Key key, this.post});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Previous Quotes"),
        backgroundColor: Colors.red,
      ),
      body: new Row(
        children: [
          new Expanded(
            child: FutureBuilder<Post>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  today = new DateTime(2019, 4, 13); //TODO: get rid of this debug line
                  return ListView.separated(
                    itemCount: 100,
                    separatorBuilder: (context, position) => Divider(),
                    itemBuilder: (context, position) {
                      var date = new DateTime(today.year, today.month, today.day - position - 2);
                      String sDate = date.year.toString() + ' ' + date.month.toString() + ' ' + String.fromCharCode(date.day + 64);
                      Map<String, List<dynamic>> quoteDataMap = snapshot.data.quoteData;
                      if (quoteDataMap.containsKey(sDate)) {
                        return new Container(
                          child: new Column(
                            children: [
                              new Row( // yesterday
                                children: [
                                  new Expanded(
                                    child: new Container(
                                      margin: const EdgeInsets.only(left: 32.0, top: 16.0, right: 32.0, bottom: 8.0),
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

                              new Row( // yesterday's date
                                //margin: const EdgeInsets.all(32.0),
                                children: [
                                  new Expanded(
                                    child: new Container(
                                      margin: const EdgeInsets.only(left: 32.0, top: 0.0, right: 32.0, bottom: 4.0),
                                      child: new Text(
                                        '\"' + quoteDataMap[sDate][0].replaceAll("\"", "\'") + '\"' ?? '',
                                        style: new TextStyle(
                                          fontSize: 20.0,
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
                                      margin: const EdgeInsets.only(right: 32.0),

                                      child: new Text(
                                        '— ' + quoteDataMap[sDate][1] ?? '',
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

/*
List<Post> list = List();

  fetchPreviousQuotesPost() async {
    final response = await(http.get('https://chrisunjae.github.io/daily-click/quote_day.txt'));
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List).map((data) => new Post.fromJson(data)).toList();
      print(list[0].quote);
    }
    else {
      throw Exception('Failed to load post');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Previous Quotes"),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: new Text(list[index].quote),
            subtitle: new Text(list[index].person),
          );
        },
      ),
    );
  }
  */
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO: figure out how to retrieve all the data as a list
// TODO: fix all this broken code

Future<Post> fetchQuotePreviousPost() async {
  final response = await http.get('https://chrisunjae.github.io/daily-click/quote_day.txt');
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
                  return ListView.builder(
                    itemBuilder: (context, position) {
                      var date = new DateTime(today.year, today.month, today.day - position);
                      String sDate = date.year.toString() + ' ' + date.month.toString() + ' ' + date.day.toString();
                      Map<String, List<dynamic>> quoteDataMap = snapshot.data.quoteData;
                      if (quoteDataMap.containsKey(sDate)) {
                        return new Container(
                          margin: const EdgeInsets.all(32.0),
                          child: new Row(
                            children: [
                              new Expanded(child: new Text(quoteDataMap[sDate][0])),
                              new Text(quoteDataMap[sDate][1]),
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
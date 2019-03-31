import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO: figure out how to retrieve all the data as a list
// TODO: fix all this broken code

var date = new DateTime.now();

class Post {

  final String quote;
  final String person;

  Post({this.quote, this.person});

  factory Post.fromJson(Map<String, dynamic> json) {
    String dateFormat = date.year.toString() + ' ' + date.month.toString() + ' ' + date.day.toString();
    return Post(
      quote: json[dateFormat + ' quote'],
      person: json[dateFormat + ' person'],
    );
  }
}

class QuotePreviousWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuotePreviousState();
  }
}

class _QuotePreviousState extends State<QuotePreviousWidget> {
  List<Post> list = List();
  var isLoading = false;
  fetchPreviousQuotesPost() async {
    setState(() {
      isLoading = true;
    });
    final response = await(http.get('https://chrisunjae.github.io/daily-click/quote_day.txt'));
    if (response.statusCode == 200) {
      (json.decode(response.body));

      //list = (json.decode(response.body) as List).map((data) => new Post.fromJson(data)).toList();
      isLoading = false;
      print('here');
    }
    else {
      throw Exception('Failed to load post');
    }
  }
  Widget build(BuildContext context) {
    fetchPreviousQuotesPost();
    return Scaffold(
      appBar: new AppBar(
        title: Text("Previous Quotes"),
        backgroundColor: Colors.red,
      ),
      body: isLoading ?
      Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          print(index);
          print(list.length);
        }
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
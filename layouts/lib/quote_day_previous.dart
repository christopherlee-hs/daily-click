import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO: figure out how to retrieve all the data as a list
// TODO: fix all this broken code

var today = new DateTime.now();

class Post {

  final List<String> quoteData;

  Post({this.quoteData});

  factory Post.fromJson(Map<String, dynamic> json, DateTime date) {
    String dateFormat = date.year.toString() + ' ' + date.month.toString() + ' ' + date.day.toString();
    return Post(
      quoteData: new List<String>.from(json[dateFormat]),
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
  Map<String, dynamic> jsonData;
  fetchPreviousQuotesPost() async {
    setState(() {
      isLoading = true;
    });
    final response = await(http.get('https://chrisunjae.github.io/daily-click/quote_day.txt'));
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      isLoading = false;
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
        itemBuilder: (BuildContext context, int index) {
          Post info = Post.fromJson(jsonData, new DateTime(today.year, today.month, today.day - index));
          return Scaffold();
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
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Post> fetchWordPost() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');
  if (response.statusCode == 200) { // server returns ok response
    return Post.fromJson(json.decode(response.body));
  }
  else { // not ok
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
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
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Word of the Day'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
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
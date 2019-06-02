import 'package:flutter/material.dart';
import 'word_day.dart';
import 'quote_day.dart';

class ListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListState();
  }
}

class _ListState extends State<ListWidget> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("The Daily Click"),
        backgroundColor: Colors.purple,
      ),
      body: new Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, position) {
            if (position < 4) {
              return RaisedButton(
                child: Text(
                  getTitle(position),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                onPressed: () {
                  if (position == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordWidget(post: fetchWordPost())
                      ),
                    );
                  }
                  else if (position == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuoteWidget(post: fetchQuotePost())
                      ),
                    );
                  }
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondRoute()
                      ),
                    );
                  }
                },
                
              );
              /*
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.album),
                      title: Text(getTitle(position)),
                      subtitle: Text(getSubTitle(position)),
                    ),
                    ButtonTheme.bar( // make buttons use the appropriate styles for cards
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('BUY TICKETS'),
                            onPressed: () {},
                          ),
                          FlatButton(
                            child: const Text('LISTEN'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              */
                /*
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {},
                  child: Text(text),
                ),
                */
            }
            /*
            if (position < 4) {
              return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.album),
                    title: Text('The Enchanted Nightingale'),
                    subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                  ),
                  ButtonTheme.bar( // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('BUY TICKETS'),
                          onPressed: () {},
                        ),
                        FlatButton(
                          child: const Text('LISTEN'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(position.toString(), style: TextStyle(fontSize: 22.0),),
              ),
            );
            }
          */
          },
        ),
      ),
    );
  }

  String getTitle(int position) {
    if (position == 0) {
      return "Word of the Day";
    }
    else if (position == 1) {
      return "Quote of the Day";
    }
    else if (position == 2) {
      return "Fact of the Day";
    }
    else if (position == 3) {
      return "Person of the Day";
    }
    return "";
  }

  String getSubTitle(int position) {
    if (position == 0) {
      return "Improve your vocabulary";
    }
    else if (position == 1) {
      return "Read the words of great men and women";
    }
    else if (position == 2) {
      return "Become a master of trivia";
    }
    return "";
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
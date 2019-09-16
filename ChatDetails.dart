import 'package:flutter/material.dart';
import 'package:flutter_app/session.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'conversations.dart';
import 'CreateConversation.dart';
bool flag=true;
class ChatDetailsApp extends StatefulWidget {
  final String other_id;

  ChatDetailsApp({Key key, @required this.other_id}) : super(key: key);

  @override
  StarWarsState createState() => StarWarsState(other_id);
}

class StarWarsState extends State<ChatDetailsApp> {
  final String other_id;

  StarWarsState(this.other_id);
  @override
  final TextEditingController _textController = new TextEditingController();
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      theme: new ThemeData(),
//      home: new ChatDetails(),
//    );
//  }
  var fut_b;
  List mychats;


//  bool flag = true;


  @override

    Widget build(BuildContext context) {
    final TextEditingController _textController = new TextEditingController();
    String p1 = "p1";
    String p2 = "p2";
    Session http_session1 = new Session();
    http_session1.post(
        'http://192.168.0.105:8080/Assgn6B/ConversationDetail',
        {"other_id": "${other_id}"}).then((response) {
      var resStatus = json.decode(response);
      print("Res : ${resStatus["status"]}");
      print("reotal : $resStatus");
      mychats = resStatus["data"];
      flag = false;
    });
    print("mychats : $mychats");
    var futureBuilder = new FutureBuilder(
      future: fut_b,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading');
          default:
            if (snapshot.hasError)
              return new Text('Error');
            else
              return createListView(context,snapshot);
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("${other_id}"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.home),
            onPressed: () =>
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ConversationsApp()),
                ),
          ),
          new IconButton(
            icon: new Icon(Icons.create),
            onPressed: () =>
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => CreateConversationApp()),
                ),
          ),
//          new IconButton(
//            icon: new Icon(Icons.exit_to_app),
//            onPressed: () => exit_fun()),


        ],
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: futureBuilder,
    );
  }
  Future<List<String>> _getData() async {
    var values = new List<String>();
    values.add("text");
    await new Future.delayed(new Duration(seconds: 5));
    return values;
  }


  Widget createListView(BuildContext context,AsyncSnapshot snapshot) {


    List<String> values = snapshot.data;
    return new Column(
      children: [
        Expanded(
          child:
          new ListView.builder(
            itemCount: mychats.length,
            itemBuilder: (BuildContext context, int index) {
              return new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(mychats[index]["text"]),
                    trailing: new Text(mychats[index]["timestamp"]),
                  ),
                  new Divider(height: 2.0),
                ],
              );
            },
            //),
          ),
        ),
        new Row(
          children: <Widget>[
            new Flexible(
              child: TextField(
                controller: _textController,
               // onSubmitted: _handle,
                //decoration: new InputDecoration.collapsed(
                //    hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handle(_textController.text),
              ),
            ),
          ],
        ),
      ],
    );
  }

//  void exit_fun()
//  {
//
//    BuildContext context;
//    Session http_session1 = new Session();
//    http_session1.post(
//        'http://192.168.0.105:8080/Assgn6B/LogoutServlet', {}).then((
//        response) {
//      var resStatus = json.decode(response);
//      print("login status : ${resStatus["status"]}");
//      print("login total : $resStatus");
//
//      Navigator.of(context).push(
//        MaterialPageRoute(builder: (context) => MyApp()),);
//    });
//
//  }

//  @override
//  void initState() {
//    super.initState();
//  }

//  @override
//  void dispose(){
//    _textController.dispose();
//    super.dispose();
//  }
  @override
  void initState() {
    fut_b=_getData();
    super.initState();
  }

  void _handle(String text) {
    BuildContext context;
    Session http_session2 = new Session();
    http_session2.post(
        'http://192.168.0.105:8080/Assgn6B/NewMessage', {"msg": text,"other_id": other_id}).then((
        response) {
      var resStatus = json.decode(response);
      print("Res : ${resStatus["status"]}");
      print("yooooo : $resStatus");
      if (resStatus["status"]) {
        print("heyyyyyy : $other_id");
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ChatDetailsApp(other_id: other_id)),
        );
      }
    });
  }
}

//class ChatDetails extends StatefulWidget {
////  static String tag = 'chatdetails';
//
//  @override
//  StarWarsState1 createState() => StarWarsState1();
//}
//
//
//class StarWarsState1 extends State<ChatDetails> {
//  final TextEditingController _textController = new TextEditingController();
//  List mychats;
//  final myController = TextEditingController();
//
//
//  @override
//  Widget build(BuildContext context) {
//    String p1 = "p1";
//    String p2 = "p2";
//    Session http_session1 = new Session();
//    http_session1.post(
//        'http://192.168.0.105:8080/Assgn6B/ConversationDetail', {}).then((
//        response) {
//      var resStatus = json.decode(response);
//      print("Res : ${resStatus["status"]}");
//      print("reotal : $resStatus");
//      mychats = resStatus["data"];
//
//    });
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("${other_id}"),
//        actions: <Widget>[
//          new IconButton(
//            icon: new Icon(Icons.home),
//            onPressed: () => Navigator.of(context).push(
//              MaterialPageRoute(builder:(context) => ConversationsApp()),
//            ),
//          ),
//          new IconButton(
//            icon: new Icon(Icons.create),
//            onPressed: () => Navigator.of(context).push(
//              MaterialPageRoute(builder:(context) => CreateConversationApp()),
//            ),
//          ),
//          new IconButton(
//            icon: new Icon(Icons.exit_to_app),
//            onPressed: () => Navigator.of(context).push(
//              MaterialPageRoute(builder:(context) => MyApp()),
//            ),
//          )
//        ],
//        backgroundColor: Colors.deepPurpleAccent,
//      ),
//
//      body: ListView.builder(
//          itemCount: mychats==null? 0 : mychats.length,
//          itemBuilder: (BuildContext context, int index){
//            return new Container(
//              child: Center(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    Card(
//                      child: Container(
//                          padding: EdgeInsets.all(15.0),
//                          child: Row(
//                            children: <Widget>[
//                              Text("text: "),
//                              Text(mychats[index]["text"],
//                                  style: TextStyle(
//                                      fontSize: 18.0, color: Colors.black87)),
//                              Text(mychats[index]["timestamp"],
//                                  style: TextStyle(
//                                      fontSize: 9.0, color: Colors.black87)),
//
//
//                            ],
//                          )),
//                    ),
//                  ],
//                ),
//
//              ),
//            );
//          }
//      ),
//
//
//
//
//    );
//
//
//  }
//

//
//  @override
//  void dispose(){
//    _textController.dispose();
//    super.dispose();
//  }
//
//  void _handle(String text){
//    Session http_session2 = new Session();
//    String p2 = "p2";
//    http_session2.post(
//        'http://192.168.0.105:8080/Assgn6B/NewMessage', {"msg": text,"other_id":p2}).then((
//        response) {
//      var resStatus = json.decode(response);
//      print("Res : ${resStatus["status"]}");
//      print("yooooo : $resStatus");
//    });
//  }
//}


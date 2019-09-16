import 'package:flutter/material.dart';
import 'package:flutter_app/session.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'ChatDetails.dart';
import 'CreateConversation.dart';
class ConversationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(),
      home: new Conversations(),
    );
  }
}

class Conversations extends StatefulWidget {
  static String tag = 'conversations';
  @override
  StarWarsState createState() => StarWarsState();
}

class StarWarsState extends State<Conversations> {
  List data;
  List dat2;
  String other_id;
  var fut_b;
  String str = "";
  String submitstr = "";

  void _onSubmit(String val)
  {
    print("Onsubmit= $val");
    setState((){
      submitstr = val;
    });
  }

  @override
  Widget build(BuildContext context) {

    void _onChanged(String value)
    {
      print("Onchange$value");
    }
    Session http_session1 = new Session();
    http_session1.post(
        'http://192.168.0.105:8080/Assgn6B/AllConversations', {}).then((
        response) {
      var resStatus = json.decode(response);
      print("Res : ${resStatus["status"]}");
      print("res total : $resStatus");
      data = resStatus["data"];
    });
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
              return createListView(context);
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
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
          new IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () =>
                exit_fun(),
                ),
        ],
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: futureBuilder,
    );
  }
  Future<List<String>> _getData() async {
    var values = new List<String>();
    await new Future.delayed(new Duration(seconds: 5));
    return values;
  }


  Widget createListView(BuildContext context){
    final TextEditingController _textController = new TextEditingController();

    return Column(
      children:[
        new Row(
          children: <Widget>[
            new Flexible(
              child:TextField(
                controller:_textController,
                onSubmitted: _handle,
                decoration: new InputDecoration.collapsed(
                    hintText: "Search"),
              ),

            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () => _handle(_textController.text),
              ),
            ),
          ],
        ),
        Expanded(
          child:
          new ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                onTap:(){
                  other_id= data[index]["uid"];
                _submit2();},
                child:new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(data[index]["uid"]),
                    //subtitle: new Text(data[index]["last_timestamp"]),
                  ),
                  new Divider(height: 2.0),
                ],
                ),
              );
            },
            //),
          ),
        ),

      ],
    );
  }

//  body: ListView.builder(
//          itemCount: data==null? 0 : data.length,
//          itemBuilder: (BuildContext context, int index){
//            return new GestureDetector(
//              onTap:(){
//                other_id= data[index]["uid"];
//                _submit2();},
//              child: Center(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
//                    Card(
//                      child: Container(
//                          padding: EdgeInsets.all(15.0),
//                          child: Row(
//                            children: <Widget>[
//                              Text("uid: "),
//                              Text(data[index]["uid"],
//                                  style: TextStyle(
//                                      fontSize: 18.0, color: Colors.black87)),
//                            ],
//                          )),
//                    ),
//                  ],
//                ),
//
//              ),
//            );
//          }
//    ),
//
//    );

  @override
  void initState() {
    fut_b=_getData();
    super.initState();
  }

void _handle(String text) {
  //_textController.clear();

//  for(int i=0; i< data.length; i++)
//    {
//      new Column(
//        children: <Widget>[
//          new ListTile(
//            title: new Text(data[i]["last_timestamp"]),
//          ),
//          new Divider(height: 2.0),
//        ],
//      );
//    }
}
  void _submit2() {
    Navigator.of(context).push(
      MaterialPageRoute(builder:(context) => ChatDetailsApp(other_id: other_id)),
      //MaterialPageRoute(builder:(context) => ChatDetailsApp()),
    );
  }

  void exit_fun()
  {
    Session http_session1 = new Session();
    http_session1.post(
        'http://192.168.0.105:8080/Assgn6B/LogoutServlet', {});
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => MyApp()),);
  }
}

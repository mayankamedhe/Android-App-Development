import 'package:flutter/material.dart';
import 'package:flutter_app/session.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'conversations.dart';
import 'ChatDetails.dart';
//import 'package:flutter/flutter_typeahead.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class CreateConversationApp extends StatelessWidget {
  //final String userid;
  //ConversationsApp({Key key, this.name}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(),
      home: new CreateConversation(),
    );
  }
}

class CreateConversation extends StatefulWidget {

  @override
  StarWarsState3 createState() => StarWarsState3();
}


class StarWarsState3 extends State<CreateConversation> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  String search;
  List data;

  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List mychats;
  String p2 = "p2";
  String val;
  @override
  Widget build(BuildContext context) {

    Session http_session1 = new Session();
    http_session1.post(
        'http://192.168.0.105:8080/Assgn6B/AutoCompleteUser',
        {"term": p2}).then((response) {
      var resStatus = json.decode(response);
      print("Res : ${resStatus["status"]}");
      print("mychats val : $resStatus");
      mychats = resStatus["data"];
      flag = false;
    });

    var textField = new AutoCompleteTextField<String>(
        decoration: new InputDecoration(
          hintText: "Search Item",
        ),
        key: key,
        submitOnSuggestionTap: false,
        clearOnSubmit: false,
//        suggestions: mychats,
//suggestions.
        suggestions: [
          "p1",
          "p2",
          "p3",
          "p4",
          "p5",
          "p6",
          "p7",
          "p8"
        ],
        textInputAction: TextInputAction.go,
        textChanged: (item) {
          currentText = item;
        },
        textSubmitted: (item) {
          setState(() {
            currentText = item;
            added.add(currentText);
            currentText = "";
          });
        },
        itemBuilder: (context, item) {
          return new Padding(
              padding: EdgeInsets.all(10.0), child: new Text(item));
        },
        itemSorter: (a, b) {
          return a.compareTo(b);
        },
        itemFilter: (item, query) {
          return item.toLowerCase().startsWith(query.toLowerCase());
        });

    Column body = new Column(children: [
      new ListTile(
          title: textField,
          trailing: new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                setState(() {
                  if (currentText != "") {
                    added.add(currentText);
                    textField.clear();
                    val = currentText;
                    currentText = "";
                  }
                });
                _handle(val);
              }))
    ]);

    body.children.addAll(added.map((item) {
      return new ListTile(title: new Text(item));
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Chat"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.home),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder:(context) => ConversationsApp()),
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.create),
            onPressed: () => print("tap"),
          ),
          new IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder:(context) => MyApp()),
            ),
          ),
        ],
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: body
//      Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: TextFormField(
//          controller:_textController,
//          decoration: InputDecoration(
//            suffixIcon: IconButton(
//              icon: Icon(Icons.search),
//              onPressed: () => _handle(_textController.text),
//            ),
//          ),
//          //hintText: 'please enter info',
//        ),
//      ),
    );


  }

//  @override
//  void initState() {
//    super.initState();
//  }
//   @override
//  void dispose(){
//    _textController.dispose();
//    super.dispose;
//   }

   void _handle(String text){
    print("val== $val");
     Session http_session2 = new Session();
     String p2 = "p6";
     http_session2.post(
         'http://192.168.0.105:8080/Assgn6B/CreateConversation', {"other_id":val}).then((
         response) {
       var resStatus = json.decode(response);
       print("Res : ${resStatus["status"]}");
       print("yooooo : $resStatus");
         Navigator.of(context).push(
           MaterialPageRoute(builder:(context) => ChatDetailsApp(other_id: val)),
         );
     });
  }
}

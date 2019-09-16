import 'package:flutter/material.dart';
import 'package:flutter_app/session.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'conversations.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(),
      home: new FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => new _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _UserID;
  String _password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      Session http_session = new Session();
//      String data = {"userid":_UserID,"password":_password};

      http_session.post('http://192.168.0.105:8080/Assgn6B/LoginServlet', {"userid":_UserID,"password":_password}).then((response) {
        var resStatus = json.decode(response);
        print("Res : ${resStatus["status"]}");
        if(resStatus["status"]) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ConversationsApp()),
          );
        }
        else
          {
            performLogin();
          }
      });

    }
  }

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Login Failed"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("Login Page"),
        ),
        body: new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new TextFormField(
                  decoration: new InputDecoration(labelText: "UserID"),
                  validator: (val) =>
                  val.length <= 1 ? 'ID incorrect' : null,
                  onSaved: (val) => _UserID = val,
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Password"),
                  validator: (val) =>
                  val.length < 0 ? 'Password too short' : null,
                  onSaved: (val) => _password = val,
                  obscureText: true,
                ),

                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new RaisedButton(
                  child: new Text(
                    "login",
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: _submit,
                )
              ],
            ),
          ),
        ));
  }
}
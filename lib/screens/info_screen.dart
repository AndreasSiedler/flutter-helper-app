import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  static final routeName = "/info-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: new Text("Info"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  child: Image.asset(
                    'assets/toe_logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "Nachbarhilfe",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Die Team Österreich Nachbarhilfe verbindet freiwillige Helfer mit Hilfsbedürftigen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
                  height: 75,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.transparent,
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', ModalRoute.withName('/')),
                    child: Text(
                      'Ausloggen',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.copyright,
                      color: Colors.white,
                    ),
                    Text(
                      "Andreas Siedler",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

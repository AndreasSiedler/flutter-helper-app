import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './jobs_overview_screen.dart';
import './jobtype_overview_screen.dart';
import './info_screen.dart';

class UsertypeOverviewScreen extends StatelessWidget {
  static const routName = '/user-typeselection';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TÖ Nachbarhilfe"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () =>
                Navigator.of(context).pushNamed(InfoScreen.routeName),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          CupertinoButton(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/want-help.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Ich möchte helfen!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    OutlineButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(JobsOverviewScreen.routeName);
                      },
                      child: Text(
                        "Los geht's",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(JobsOverviewScreen.routeName);
            },
          ),
          Expanded(
            child: CupertinoButton(
              padding: EdgeInsets.all(20),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/need-help.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Ich brauche Unterstützung!",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      OutlineButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              JobtypeOverviewScreen.routeName);
                        },
                        child: Text(
                          "Los geht's",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 19,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(JobtypeOverviewScreen.routeName);
              },
            ),
          ),
        ],
      )),
    );
  }
}

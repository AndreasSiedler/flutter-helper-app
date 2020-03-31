import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../providers/jobs.dart';
import '../widgets/badge.dart';

class JobDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final jobId = ModalRoute.of(context).settings.arguments as String;
    // Lean widgets and put the logic into provider
    // Dont want to rebuild if data changes HERE so: listen: false
    // Use this if you need data only one time but not interested in updates
    final loadedJob = Provider.of<Jobs>(context, listen: false).findById(jobId);

    return Scaffold(
        appBar: AppBar(
          title: Text(loadedJob.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Image.asset(
                  'assets/detail/${loadedJob.imageName}.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(40, 40, 40, 20),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${loadedJob.name} benötigt deine Hilfe",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            size: 15.0,
                          ),
                          Text(
                            _getActiveFromInMinutes(loadedJob.activeFrom),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Icon(
                            Icons.location_on,
                            size: 15.0,
                          ),
                          Text(
                            isNumeric(loadedJob.location)
                                ? "${loadedJob.location}. Bezirk"
                                : loadedJob.location.toUpperCase(),
                            style: TextStyle(fontSize: 15.0),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Treten Sie mit ${loadedJob.name} rasch in Kontakt um zu helfen!",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton(
                              heroTag: "btn1",
                              onPressed: () => _callUser(loadedJob.phone),
                              child: Icon(Icons.call),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton(
                              heroTag: "btn2",
                              onPressed: () => _messageUser(loadedJob.phone),
                              child: Icon(Icons.message),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ));
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String _getActiveFromInMinutes(int activeFrom) {
    final fifteenAgo =
        DateTime.fromMillisecondsSinceEpoch(activeFrom);
    return timeago.format(fifteenAgo);
  }

  void _messageUser(String phone) async {
    try {
      if (Platform.isAndroid) {
        //FOR Android
        final url = 'sms:$phone?body=Hallo%20ich%20bin%27s%2C%20deine%20Hilfe%20von%20Team%20Österreich%20...';
        await launch(url);
      } else if (Platform.isIOS) {
        //FOR IOS
        final url = 'sms:$phone';
        await launch(url);
      }
    } catch (err) {
      print(err);
    }
  }

  void _callUser(String phone) async {
    try {
      final response = await launch("tel://$phone");
      print(response);
    } catch (err) {
      print(err);
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timeago/timeago.dart' as timeago;

import '../providers/job.dart';
import '../screens/job_detail_screen.dart';

class JobItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final job = Provider.of<Job>(context, listen: false);

    return CupertinoButton(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/overview/${job.imageName}.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${job.title}",
                        style: TextStyle(
                          color: _setTextColor(job.imageName),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "${job.name} braucht dich!",
                        style: TextStyle(
                          color: _setTextColor(job.imageName),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.timer,
                    size: 15.0,
                  ),
                  Text(
                    _getActiveFromInMinutes(job.activeFrom),
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Icon(
                    Icons.location_on,
                    size: 15.0,
                  ),
                  Text(
                    isNumeric(job.location)
                        ? "${job.location}. Bezirk"
                        : job.location.toUpperCase(),
                    style: TextStyle(fontSize: 15.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onPressed: () {
        Navigator.of(context)
            .pushNamed(JobDetailScreen.routeName, arguments: job.id);
      },
    );
  }

  String _getActiveFromInMinutes(int activeFrom) {
    final fifteenAgo =
        DateTime.fromMillisecondsSinceEpoch(activeFrom);
    return timeago.format(fifteenAgo);
  }

  Color _setTextColor(String imageName) {
    if (imageName == 'jt_pharmacy' || imageName == 'jt_transport') {
      return Colors.white;
    } else {
      return Colors.black87;
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}

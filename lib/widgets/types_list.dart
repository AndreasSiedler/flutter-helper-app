import 'package:flutter/material.dart';

class JobList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              "Wobei benötigen Sie hilfe?",
              style: TextStyle(fontSize: 40),
            ),
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(color: Colors.red, height: 150.0),
                Container(color: Colors.purple, height: 150.0),
                Container(color: Colors.green, height: 150.0),
                Container(color: Colors.red, height: 150.0),
                Container(color: Colors.purple, height: 150.0),
                Container(color: Colors.green, height: 150.0),
                Container(color: Colors.red, height: 150.0),
                Container(color: Colors.purple, height: 150.0),
                Container(color: Colors.green, height: 150.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}

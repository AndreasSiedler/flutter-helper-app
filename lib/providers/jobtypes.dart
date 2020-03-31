import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Jobtype with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageName;
  bool isActive;

  Jobtype(@required this.id, @required this.title, @required this.description,
      @required this.imageName,
      {this.isActive = false});

  void toggleActiveStatus() {
    this.isActive = !this.isActive;
    notifyListeners();
  }
}

class Jobtypes with ChangeNotifier {

  List<Jobtype> _items = [];

  Future<void> fetchJobTypes() async {
    const url = 'https://helper-app-7a1e8.firebaseio.com/job_types.json';
    try {
      final response = await http.get(url);
      // Convert response
      List<Jobtype> loadedJobTypes = [];
      final decodedjobTypeMap =
          json.decode(response.body) as Map<String, dynamic>;
      decodedjobTypeMap.forEach((key, value) {
        // print(value);
        loadedJobTypes
            .add(Jobtype(key, value['title'], value['description'], value['imageName']));
      });
      // print(loadedJobTypes);
      _items = loadedJobTypes;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Jobtype> get items {
    return [..._items];
  }
}

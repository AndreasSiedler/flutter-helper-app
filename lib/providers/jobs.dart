import 'dart:convert';

import 'package:flutter/material.dart';
import '../helpers/location_helper.dart';
import 'package:http/http.dart' as http;

import './job.dart';

class Jobs with ChangeNotifier {
  // Not a final list because it will change overtime
  // Because of _ it cant accessed from outside
  List<Job> _items = [];

  // var _showFavoritsOnly = false;

  // Getter which returns a copy of the items
  List<Job> get items {
    // if (_showFavoritsOnly) {
    //   return _items.where((jobItem) => jobItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Job> get favoriteItems {
    return _items.where((jobItem) => jobItem.isFavorite).toList();
  }

  Job findById(String id) {
    return _items.firstWhere((job) => job.id == id);
  }

  Future<void> fetchAndSetJobs(String locationId) async {
    var url = 'https://helper-app-7a1e8.firebaseio.com/jobs.json?orderBy="location"&equalTo="$locationId"';
    try {
      final response = await http.get(url);
      // You can put the type before the name or on the end with an as.
      // You cannot put a Map into <> like Map<String, Map> => dynamic instead
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Job> loadedJobs = [];
      
      extractedData.forEach((key, value) => {
            // Use insert to put it on start of list
            // Access Map properties with ['<prpertyname'>]
            loadedJobs.insert(
                0,
                Job(
                  id: key,
                  title: value['title'],
                  description: value['description'],
                  imageName: value['imageName'],
                  name: value['name'],
                  phone: value['phone'],
                  location: value['location'],
                  activeFrom: value['activeFrom'],
                ))
          });
      // Sort by activFrom
      loadedJobs.sort((b, a) => a.activeFrom.compareTo(b.activeFrom));

      _items = loadedJobs;
      print(response);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // Define the Return Type <void> means no value is returned
  Future<dynamic> addJob(
    String title,
    String description,
    String imageName,
    String jobType,
    String name,
    String phone,
    String location,
  ) async {
    try {
      final locationNameList = await LocationHelper.fetchLocations();
      final Map locationMap = locationNameList
          .firstWhere((item) => item['value'] == location, orElse: () => null);

      // Remove the .json to test error request
      const url = 'https://helper-app-7a1e8.firebaseio.com/jobs.json';
      // Important to return the Future of post which returns the future of .then
      final response = await http.post(
        url,
        body: json.encode({
          'title': title,
          'description': description,
          'imageName': imageName,
          'name': name,
          'phone': phone,
          'location': location,
          'activeFrom': DateTime.now().millisecondsSinceEpoch,
        }, toEncodable: myEncode),
      );

      final id = json.decode(response.body);
      //Return Firebase Item Id
      return id['name'];
    } catch (error) {
      print(error);
      throw error;
    }

    // Catches error which could occured in post or .then
    // through throw error we can catch the error from calling addJob() somewhere in the code
  }

  Future<void> removeJob(String id) async {
    var url = 'https://helper-app-7a1e8.firebaseio.com/jobs/' + id + '.json';

    try {
      // HIER MUSS response verwender werden sonst kein throw error
      final response = await http.delete(url);
      print(json.decode(response.body));
    } catch (err) {
      throw err;
    }
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}

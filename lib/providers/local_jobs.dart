import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/db_helper.dart';

class LocalJob with ChangeNotifier {
  final String id; // -2345eger3twer
  final String jobtype; // jt2
  bool isActive;

  LocalJob(@required this.id, @required this.jobtype, this.isActive);

  void toggleActiveStatus() {
    this.isActive = !this.isActive;
    notifyListeners();
  }
}

class LocalJobs with ChangeNotifier {
  List<LocalJob> _items = [];

  List<LocalJob> get items {
    return [..._items];
  }

  LocalJob findById(String id) {
    return _items.firstWhere((item) => item.jobtype == id, orElse: () => null);
  }

  Future<void> addLocalJob(String id, String jobTypeId) {
    _items.add(LocalJob(id, jobTypeId, true));
    notifyListeners();
    return DBHelper.insert('active_jobs', {
      'id': id,
      'jobtype': jobTypeId,
      'active': 1,
    });
  }

  Future<void> removeLocalJob(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    return DBHelper.delete('active_jobs', id);
  }

  Future<void> fetchLocalJobs() {
    return DBHelper.getData('active_jobs').then((data) {
      data.forEach((item) {
        _items.add(LocalJob(
            item['id'], item['jobtype'], item['active'] == 1 ? true : false));
      });
      notifyListeners();
    });
  }
}

import 'package:flutter/foundation.dart';
import '../helpers/db_helper.dart';

class User with ChangeNotifier {
  // final String id;

  String _name = "";
  String _phone = "";
  String _location = "";
  bool _acceptedTerms = false;

  String get name {
    return _name;
  }

  String get phone {
    return _phone;
  }

  String get location {
    return _location;
  }

  bool get acceptedTerms {
    return _acceptedTerms;
  }

  void storeUser(
      String name, String phone, String location, bool acceptedTerms) async {
    _name = name;
    _phone = phone;
    _location = location;
    _acceptedTerms = acceptedTerms;
    try {
      await DBHelper.insert('user_data', {
        'id': "0",
        'firstname': name,
        'phone': phone,
        'location': location,
        'acceptedTerms': acceptedTerms ? 1 : 0,
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> fetchAndSetUserData() async {
    try {
      final userData = await DBHelper.getData('user_data');
      final list = userData.map((item) {
        // All values in Map are Strings
        if (item['id'] == "0") {
          _name = item['firstname'];
          _phone = item['phone'];
          _location = item['location'];
          _acceptedTerms = item['acceptedTerms'] == 1 ? true : false;
        }
      }).toList();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}

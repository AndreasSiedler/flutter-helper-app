import 'dart:convert';
import 'package:http/http.dart' as http;

// const GOOGLE_API_KEY = 'AIzaSyBg9yn5JtQgKRFbg6FCTy4ewbF24kRuAYI';

class LocationHelper {
  // static String generateLocationPreviewImage({
  //   double latitude,
  //   double longitude,
  // }) {
  //   return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  // }

  // static Future<List> getCurrentLocation() async {
  //   final locData = await Location().getLocation();
  //   return [locData.latitude, locData.longitude];
    // final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
    //   latitude: locData.latitude,
    //   longitude: locData.longitude,
    // );
  // }

  static Future<List<Map>> fetchLocations() async {
    const url = 'https://helper-app-7a1e8.firebaseio.com/locations.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map;

      List<Map<String, String>> loadedLocationList = [];
      extractedData.forEach((key, value) {
        loadedLocationList.add({
          'value': key,
          'name': value,
        });
      });
      return loadedLocationList;
    } catch (error) {
      throw error;
    }
  }
}

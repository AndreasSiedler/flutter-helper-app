import 'package:flutter/foundation.dart';

class Job with ChangeNotifier {
  final String id;
  // final String type;
  final String title;
  final String description;
  final String imageName;
  final String name;
  final String phone;
  final String location;
  final int activeFrom;
  bool isFavorite;

  Job({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageName,
    @required this.name,
    @required this.phone,
    @required this.location,
    @required this.activeFrom,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    // notifyListeners is the equivalent to setState in state Widgets
    notifyListeners();
  }
}

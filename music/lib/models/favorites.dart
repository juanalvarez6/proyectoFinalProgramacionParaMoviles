import 'package:flutter/foundation.dart';
import 'package:music/models/song.dart';

class FavoriteModels extends ChangeNotifier {
  final List<Song> _favoriteItems = [];

  List<Song> get items => _favoriteItems;

  void add(Song itemNo) {
    _favoriteItems.add(itemNo);
    notifyListeners();
  }

  void remove(Song itemNo) {
    _favoriteItems.remove(itemNo);
    notifyListeners();
  }
}

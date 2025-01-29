import 'package:flutter/material.dart';

import '../db/db.dart';

class BooksProvider with ChangeNotifier {
  BooksProvider() {
    _books = db.sql.books.get();
  }
  newHabit() {
    _books = db.sql.books.get();
    notifyListeners();
  }

  habitUpdated() {
    _books = db.sql.books.get();
    notifyListeners();
  }

  var _books;
  get books => _books;
}

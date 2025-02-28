import 'package:flutter/material.dart';

import '../db/db.dart';

class BookProvider with ChangeNotifier {
  BookProvider() {
    _Books = db.sql.books.get();
  }
  newBook() {
     _Books = db.sql.books.get();
    notifyListeners();
  }

  bookUpdated() {
     _Books = db.sql.books.get();
    notifyListeners();
  }

  var _Books;
  get Books => _Books;
}

import '../../../db/db.dart';

abstract class Log {
  final String name;
  Log(this.name);
  getLogsPerDate(String date);
}

class LogBook extends Log {
  LogBook() : super("Book");
  @override
  getLogsPerDate(String date) {
    return db.sql.books.getLogByDate(date);
  }
}

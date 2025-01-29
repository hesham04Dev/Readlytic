import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:readlytic/db/sql_class.dart';
import 'package:sqlite3/sqlite3.dart';

class DbHelper {
  final _supportDir = getApplicationSupportDirectory();
  late final String dbPath;

  late Database db;
  late Sql sql;

  Future<void> openDb() async {
    final dir = await _supportDir;
    dbPath = "${dir.path}/hcody_ab.db";
    print(dbPath);
    _restoreIfExists();
    db = sqlite3.open(dbPath);
    createTablesIfNotExists(db);
    sql = Sql(db);
    sql.settings.updateStreak();
  }

  void _restoreIfExists() async {
    var dir = await _supportDir;
    File restored = File('${dir.path}/restored.db');
    if (await restored.exists()) {
      print("restoring");
      File old = File(dbPath);
      await old.delete();
      await restored.rename(dbPath);
    }
  }

  void createTablesIfNotExists(Database db) {
    const String createStateTable = '''
  CREATE TABLE IF NOT EXISTS state(
  Id INTEGER PRIMARY KEY AUTOINCREMENT,
  key TEXT unique,
  );
  INSERT OR IGNORE INTO  category (Name) values ('to_read'),('reading'),('done'),('stopped');
  ''';
    const String createBooksTable = '''
  CREATE TABLE IF NOT EXISTS books ( 
                id INTEGER PRIMARY KEY AUTOINCREMENT,  
                title TEXT NOT NULL,  
                author TEXT,  
                total_pages INTEGER NOT NULL,  
                current_page INTEGER DEFAULT 0,  
                average_reading_time REAL DEFAULT 0,  
                rating REAL DEFAULT 0,  
                categories TEXT,  
                status_id INTEGER DEFAULT 2,  
                description TEXT,  
                notes TEXT,  
                reading_sessions INTEGER DEFAULT 0,  
                FOREIGN KEY (status_id) REFERENCES status(id));

  ''';
    const String createSettingTable = '''
  CREATE TABLE IF NOT EXISTS setting(
  Id INTEGER PRIMARY KEY,
  Name TEXT,
  Val INTEGER
  );
  INSERT OR IGNORE INTO setting(Id,Name,Val) values (1,'Coins',0),(2,'DarkMode',0),(3,'AccentColor',0),(4,'NotificationTime',0),(5,'Streak',1),(6,'ListView',0);  ''';
    const String createReadingLogsTable = '''
  CREATE TABLE IF NOT EXISTS  reading_logs ( 
 id INTEGER PRIMARY KEY AUTOINCREMENT,  
 book_id INTEGER NOT NULL,  
 date TEXT DEFAULT CURRENT_TIMESTAMP,  
 reading_time REAL NOT NULL,  
 pages_read INTEGER NOT NULL,  
 FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE);''';

// Triggers
    const String createUpdateBookAfterReadingTrigger = '''
CREATE TRIGGER update_book_after_reading  
  AFTER INSERT ON reading  
  BEGIN  
  UPDATE books  
  SET current_page = current_page  NEW.pages  
  WHERE id = NEW.book_id;  
  UPDATE books  
  SET rating = (SELECT AVG(reading_time) FROM reading WHERE book_id = NEW.book_id)  
  WHERE id = NEW.book_id;  
  UPDATE books  
  SET status_id = 1, reading_count = reading_count  1  
  WHERE id = NEW.book_id AND current_page >= pages;  
  END;
''';
    const String createUpdateAvgReadingTime = '''
CREATE TRIGGER update_avg_reading_time  
  AFTER UPDATE OF current_page ON books  
  WHEN NEW.current_page < OLD.current_page  
  BEGIN  
  UPDATE books SET average_reading_time = (SELECT SUM(reading_time) / SUM(pages_read) FROM reading_logs WHERE book_id = NEW.id) WHERE id = NEW.id;  
  END;
''';

    const List<String> sqlList = [
      createSettingTable,
      createStateTable,
      createBooksTable,
      createReadingLogsTable,
      createUpdateBookAfterReadingTrigger,
      createUpdateAvgReadingTime
    ];
    for (String sql in sqlList) {
      db.execute(sql);
    }
  }
}

var db = DbHelper();

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:readlytic/config/const.dart';
import 'package:sqlite3/sqlite3.dart';

import 'sql_class.dart';

class DbHelper {
  final _supportDir = getApplicationSupportDirectory();
  late final String dbPath;

  late Database db;
  late Sql sql;

  Future<void> openDb() async {
    final dir = await _supportDir;
    dbPath = "${dir.path}/hcody_$kAppName.db";
    print(dbPath);
    _restoreIfExists();
    db = sqlite3.open(dbPath);
    createTablesIfNotExists(db);
    sql = Sql(db);
    // sql.settings.updateStreak();
    // moved to inside the update book or addreading
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
    const String createCategoryTable = '''
  CREATE TABLE IF NOT EXISTS category(
  Id INTEGER PRIMARY KEY AUTOINCREMENT,
  Name TEXT unique,
  IconId INTEGER DEFAULT 0,
  EarnedXp INTEGER DEFAULT 0,
  MaxXp INTEGER DEFAULT 100,
  Level INTEGER DEFAULT 1
  );
  INSERT OR IGNORE INTO  category (Name) values('main');
  ''';
    const String createHabitTable = '''
  CREATE TABLE IF NOT EXISTS habit(
  Id INTEGER PRIMARY KEY AUTOINCREMENT,
  Name TEXT,
  Category INTEGER,
  IsBad BOOLEAN,
  Price int,
  IconId INTEGER,
  Priority INTEGER,
  Hardness INTEGER,
  TimeInMinutes INTEGER,
  IsArchived BOOLEAN DEFAULT 0,
  FOREIGN KEY(Category) REFERENCES category(Id)
  )''';
    const String createGiftTable = '''
  CREATE TABLE IF NOT EXISTS gift(
  Id INTEGER PRIMARY KEY AUTOINCREMENT,
  Name TEXT,
  Price INTEGER,
  IconId INTEGER,
  IsArchived BOOLEAN DEFAULT 0,
  NoOfUsed INTEGER DEFAULT 0
  )

  ''';
    const String createSettingTable = '''
  CREATE TABLE IF NOT EXISTS setting(
  Id INTEGER PRIMARY KEY,
  Name TEXT,
  Val INTEGER
  );
  INSERT OR IGNORE INTO setting(Id,Name,Val) values (1,'Coins',0),(2,'DarkMode',0),(3,'AccentColor',0),(4,'NotificationTime',0),(5,'Streak',1),(6,'ListView',0);  ''';
    const String createLogGiftTable = '''
  CREATE TABLE IF NOT EXISTS logGift(
  DateOnly TEXT,
  GiftId INTEGER,
  Count INTEGER,
  PRIMARY KEY (GiftId, DateOnly),
  FOREIGN KEY (GiftId) REFERENCES gift(Id)
  )''';
    const String createLogHabitTable = '''
  CREATE TABLE IF NOT EXISTS logHabit(
  DateOnly TEXT,
  HabitId INTEGER,
  Count INTEGER,
  PRIMARY KEY (HabitId, DateOnly),
  FOREIGN KEY (HabitId) REFERENCES habit(Id)
  )''';
    const String createStatusTable = '''
            CREATE TABLE  IF NOT EXISTS status (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE);
            INSERT OR IGNORE INTO status (name) VALUES ('Reading'), ('Stopped'), ('Completed'), ('Later');
            ''';
    const String createBookTable = '''
            CREATE TABLE IF NOT EXISTS  books (id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            author TEXT,
            total_pages INTEGER NOT NULL,
            current_page INTEGER DEFAULT 0,
            average_reading_time REAL DEFAULT 0,
            rating REAL DEFAULT 0,
            categories TEXT,
            status_id INTEGER DEFAULT 3,
            notes TEXT,
            reading_count INTEGER DEFAULT 0,
            FOREIGN KEY (status_id) REFERENCES status(id) ON DELETE CASCADE);
''';
    const String createReadingLogTable = '''
                    CREATE TABLE  IF NOT EXISTS reading_logs (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    book_id INTEGER NOT NULL,
                    date TEXT DEFAULT CURRENT_TIMESTAMP,
                    reading_time REAL NOT NULL,
                    pages_read INTEGER NOT NULL,
                    trig INTEGER NOT NULL DEFAULT 1,
                    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE);

''';
    const String createTriggerReglage = '''
          CREATE TRIGGER IF NOT EXISTS reglage_pages_read AFTER INSERT ON reading_logs
          WHEN NEW.trig = 1
          BEGIN
          UPDATE reading_logs
          SET pages_read = MIN(
          NEW.pages_read,
          (SELECT total_pages - current_page
          FROM books
          WHERE id = NEW.book_id))
          WHERE id = NEW.id;
          END;
''';
    const String createTriggerUpdateCurrent = '''
    CREATE TRIGGER IF NOT EXISTS update_current_page_from_log AFTER UPDATE ON    reading_logs
         WHEN NEW.trig = 1
         BEGIN
         UPDATE books
         SET status_id = 1, reading_count = reading_count + 1
         WHERE id = NEW.book_id AND current_page = total_pages;
         UPDATE books
         SET current_page = current_page + NEW.pages_read,
         average_reading_time = (average_reading_time * (1 - (CAST(NEW.pages_read AS REAL) / total_pages)) +
         (NEW.reading_time / CAST(total_pages AS REAL)))
         WHERE id = NEW.book_id;
         END;
''';
    const String createTriggerAddReading =
    //  '''
// CREATE TRIGGER IF NOT EXISTS add_reading_from_book_update
//  AFTER UPDATE OF current_page ON books
//  WHEN NEW.current_page > OLD.current_page  // Prevent negative page changes
//  BEGIN
//  UPDATE books
//  SET current_page = CASE
//  WHEN NEW.current_page >= total_pages THEN total_pages
//  ELSE NEW.current_page END,
//  status_id = CASE
//  WHEN NEW.current_page >= total_pages THEN 1
//  ELSE status_id END,
//  reading_count = CASE
//  WHEN NEW.current_page >= total_pages THEN reading_count + 1
//  ELSE reading_count END
//  WHERE id = NEW.id;
//  INSERT INTO reading_logs(book_id, reading_time, pages_read, trig)
//  VALUES(NEW.id, NEW.average_reading_time * (NEW.current_page - OLD.current_page),
//  (NEW.current_page - OLD.current_page), 0);
//  END;"
// '''
'''
CREATE TRIGGER IF NOT EXISTS add_reading_from_book_update
AFTER UPDATE OF current_page ON books
WHEN NEW.current_page > OLD.current_page -- Prevent negative page changes
BEGIN
    UPDATE books
    SET current_page = CASE
        WHEN NEW.current_page >= total_pages THEN total_pages
        ELSE NEW.current_page
    END,
    status_id = CASE
        WHEN NEW.current_page >= total_pages THEN 1
        ELSE status_id
    END,
    reading_count = CASE
        WHEN NEW.current_page >= total_pages THEN reading_count + 1
        ELSE reading_count
    END
    WHERE id = NEW.id;

    INSERT INTO reading_logs (book_id, reading_time, pages_read, trig)
    VALUES (
        NEW.id,
        NEW.average_reading_time * (NEW.current_page - OLD.current_page),
        (NEW.current_page - OLD.current_page),
        0
    );
END;
'''

;
    const List<String> sqlList = [
      createCategoryTable,
      createHabitTable,
      createGiftTable,
      createLogGiftTable,
      createLogHabitTable,
      createSettingTable,
      createStatusTable,
      createBookTable,
      createReadingLogTable,
      createTriggerReglage,
      createTriggerUpdateCurrent,
      createTriggerAddReading
    ];
    for (String sql in sqlList) {
      db.execute(sql);
    }
  }
}

var db = DbHelper();

// TODO remove cat, habit,gift ,logs

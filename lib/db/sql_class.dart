import 'package:intl/intl.dart';
import 'package:sqlite3/sqlite3.dart';

//TODO
final DateTime now = DateTime.now();
final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

class Sql {
  late final Database _db;

  Sql(this._db) {
    books = BookFn(_db);
    settings = SettingFn(_db);
  }

  late BookFn books;
  late SettingFn settings;
  //late StatisticFn statistics;
}

class BookFn {
  final Database _db;

  BookFn(this._db);

  ResultSet get({bool getAll = false}) {
    String sql = '''
  SELECT habit.* ,state.name
FROM habit
Inner JOIN (
    SELECT Id, Name
    FROM state
) AS state ON habit.state_Id = state.Id
WHERE 1 ;
  ''';
    if (getAll) {
      sql += "and state.name = 'reading'";
    }
    ResultSet resultSet = _db.select(sql);
    return resultSet;
  }



  ResultSet getTopDay() {
    // TODO
    ResultSet x = _db.select('''
SELECT lh.DateOnly , SUM(lh.Count * h.Price) AS Total
FROM habit AS h
INNER JOIN logHabit AS lh ON h.Id = lh.HabitId
GROUP BY lh.DateOnly
ORDER BY SUM(lh.Count * h.Price) DESC
LIMIT 1;
  ''');

    return x;
  }

  ResultSet getWeeklyData() {
    // TODO 
    var x = _db.select('''
    SELECT lh.DateOnly, 
    SUM(CASE WHEN h.IsBad = False THEN lh.Count * h.Price ELSE 0 END) - 
    SUM(CASE WHEN h.IsBad = True THEN lh.Count * h.Price ELSE 0 END) AS Total
    FROM habit AS h INNER JOIN logHabit AS lh ON h.Id = lh.HabitId
    GROUP BY lh.DateOnly
    ORDER BY lh.DateOnly DESC
    LIMIT 7;''');
    return x;
  }

  ResultSet getLogByDate(String date) {
    return _db.select(
        "select  logHabit.*,habit.Name from logHabit inner join habit on logHabit.HabitId = habit.Id where DateOnly = '$date'");
  }
  // ?

  ResultSet getDatesOfLog() {
    return _db.select(
        "select distinct DateOnly from logHabit order by DateOnly desc ");
  }
  // ?

  void addToLog(int id) {
    // TODO
    _db.execute('''
      insert into logHabit values('$formattedDate',$id,1)
      ''');
  }


  void update(habit) {
    _db.execute('''UPDATE habit set Name = '${habit.name}',
  Category = ${habit.categoryId},
  IsBad = ${habit.isBadHabit},
  IconId = ${habit.iconId},
  Priority = ${habit.priority},
  Hardness = ${habit.hardness},
  Price = ${habit.price},
  TimeInMinutes = ${habit.timeInMinutes}
  WHERE Id = ${habit.id} ''');
  }

  void delete({required int id}) {
    _db.execute("delete from logHabit where HabitId = ?", [id]);
    _db.execute("delete from habit where Id = $id");
  }



  void add(
    // TODO
      {required String name,
      required int categoryId,
      required bool isBad,
      required int price,
      required int iconId,
      required int priority,
      required int hardness,
      required int timeInMinutes}) {
    _db.execute(
        "INSERT INTO habit('Name','Category','IsBad','Price','IconId','Priority','Hardness','TimeInMinutes') VALUES ('$name',$categoryId,$isBad,$price,$iconId,$priority,$hardness,$timeInMinutes)");
  }
}

class SettingFn {
  final Database _db;

  SettingFn(this._db);

  void updateStreak() {
    DateTime lastDay =
        DateTime.parse(_getLastDay() ?? DateTime.now().toString());
    print(now.difference(lastDay).inDays);
    int diff = now.difference(lastDay).inDays;
    if (diff == 1) {
      _db.execute(
          '''UPDATE setting set Val = Val +1  WHERE Name = 'Streak' ''');
    } else if (diff != 0) {
      _db.execute('''UPDATE setting set Val = 1  WHERE Name = 'Streak' ''');
    }
  }

  int getStreak() {
    ResultSet r = _db.select("select Val from setting where Name = 'Streak'");
    return r[0]["Val"];
  }

  String? _getLastDay() {
    ResultSet r = _db
        .select("select DateOnly from logHabit Order by DateOnly DESC Limit 1");
    return r.isEmpty ? null : r[0]["DateOnly"];
  }

  int getAccentColorIndex() {
    var x =
        _db.select('''SELECT Val from setting where Name = 'AccentColor' ''');
    return x[0]['Val'];
  }

  void setAccentColor(val) {
    _db.execute("UPDATE setting set Val = $val WHERE Name = 'AccentColor' ");
  }

  bool getDarkMode() {
    var x = _db.select('''SELECT Val from setting where Name = 'DarkMode' ''');
    if (x[0]['Val'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  void setDarkMode(val) {
    _db.execute("UPDATE setting set Val = $val WHERE Name = 'DarkMode' ");
  }

  bool isListView() {
    var x = _db.select('''SELECT Val from setting where Name = 'ListView' ''');
    if (x[0]['Val'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  void setIsListView(bool val) {
    _db.execute(
        "UPDATE setting set Val = ${val ? 1 : 0} WHERE Name = 'ListView' ");
  }

  getNotificationTime() {
    var x = _db
        .select('''SELECT Val from setting where Name = 'NotificationTime' ''');
    return x[0]['Val'];
  }

  void setNotificationTime(val) {
    _db.execute(
        "UPDATE setting set Val = $val WHERE Name = 'NotificationTime' ");
  }
}

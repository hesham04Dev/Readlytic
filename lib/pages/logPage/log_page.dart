import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../../db/db.dart';
import 'models/log.dart';
import 'widgets/log_container.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    sqlite.ResultSet logHabitDates = db.sql.books.getDatesOfLog();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log"),
      ),
      body: LogContainer(dates: logHabitDates, log: LogBook()),
    );
  }
}

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readlytic/config/const.dart';
import 'package:restart_app/restart_app.dart';

Future<void> backup() async {
  String pathToDownloadsDir;
  if (Platform.isAndroid) {
    pathToDownloadsDir = "/storage/emulated/0/Download";
  } else {
    final downloadsDir = await getDownloadsDirectory();
    pathToDownloadsDir = downloadsDir!.path;
  }
  String date = DateFormat('yyyy_MM_dd_kk_mm').format(DateTime.now());
  String path  = "$pathToDownloadsDir/$kAppName/";
  Directory folder = Directory(path);
  bool isFolderExists = await folder.exists();
  if (!isFolderExists) {
    folder.create();
  }
  String backupPath =
      "$path/hcody_${kAppName}_backup$date.db";
  File file = File(backupPath);
  if (await file.exists()) {
    await file.delete();
  }
  //Database? backup = sqlite3.open(backupPath);
  //db.backup(backup, nPage: -1);
  //backup.dispose();
  File originalFile =
      File("${(await getApplicationSupportDirectory()).path}/$kAppName.db");

  originalFile
      .copy("$pathToDownloadsDir/achievement_box/${kAppName}_backup$date.db");
}

Future<void> restore(String path) async {
  final supportDir = await getApplicationSupportDirectory();
  //db.dispose();
  File sourceFile = File(path);
  sourceFile.copySync('${supportDir.path}/restored.db');
  if (Platform.isAndroid) {
    Restart.restartApp();
  }
  //we need to restart the app to restore the db;
}

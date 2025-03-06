
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:readlytic/pages/homePage/Bodies/settingBody/Widget/ColorDialog.dart';

import '../../../../db/db.dart';
import '../../../../widgets/imageIcon.dart';
import '../../../../widgets/mySwitchTile.dart';
import '../../../../rootProvider/ThemeProvider.dart';
import '../../../../rootProvider/settings_controller.dart';
import '../../../logPage/log_page.dart';
import 'Widget/MyListTile.dart';
import 'Widget/backup.dart';
import 'Widget/restore_tile.dart';

class SettingBody extends StatefulWidget {
  const SettingBody({super.key});

  @override
  State<SettingBody> createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  @override
  Widget build(BuildContext context) {
    Widget darkModeTile = MySwitchTile(
      title: "darkMode",
      value: db.sql.settings.getDarkMode(),
      onChange: (bool value) {
        value ? db.sql.settings.setDarkMode(1) : db.sql.settings.setDarkMode(0);
        context.read<ThemeProvider>().toggleMode();
      },
    );
      return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          darkModeTile,
          MyListTile(
            title: 'Accent Color',
            trailing: IconImage(
              iconName: "circle.png",
            ),
            onTap: () {
              showDialog(context: context, builder: (context) => ColorDialog());
            },
          ),
          BackupTile(),
          /*not constant*/
          RestoreTile(),
          /*not constant*/
          MyListTile(
            title: 'View on Github',
            trailing: IconImage(
              iconName: "github-alt.png",
            ),
            onTap: () async {
              await Clipboard.setData(const ClipboardData(
                  text: "https://github.com/hesham04Dev/Readlytic"));
            },
          ),
          // MyListTile(
          //     title: "Log page",
          //     trailing: IconImage(
          //       iconName: "rectangle-history.png",
          //     ),
          //     onTap: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => const LogPage()));
          //     }),

          MyListTile(
            title: 'Version: ${SettingsController.appVersion}',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

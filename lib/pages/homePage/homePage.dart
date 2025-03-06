
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:readlytic/config/const.dart";

import "Bodies/HomeBody/homeBody.dart";
import "Bodies/providers/pageIndexProvider.dart";
import "Bodies/statisticBody/statisticBody.dart";
import "Bodies/settingBody/settingPage.dart";
import "widget/BottomNavigationBar.dart";
import "widget/myFab.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var bodiesController = context.read<PageIndexProvider>().bodiesController;

    List<Widget> bodies = [
      const SettingBody(),
      const HomeBody(),
      const StatisticsBody()
    ];
 
  
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title:  Text(
            kAppName.toUpperCase(),
          ),
        ),
        body: PageView(
          onPageChanged: (index) {
            context.read<PageIndexProvider>().pageIndexChanged(index);
          },
          controller: bodiesController,
          children: bodies,
        ),
        floatingActionButton: const MyFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: const MyBottomNavigationBar());
  }
}


import 'package:flutter/material.dart';

import '../../../../db/db.dart';
import '../../../../fn/time_lable.dart';
import '../../../../models/imageIcon.dart';

import 'widget/statisticBar.dart';
import 'widget/weeklyBar.dart';

class StatisticsBody extends StatelessWidget {
  const StatisticsBody({super.key});

  @override
  Widget build(BuildContext context) {
    // final topHabit = db.sql.habits.getTop();
    // final topGift = db.sql.gifts.getTop();
    final topDay = db.sql.books.getTopDay();
    final streak = db.sql.settings.getStreak();
    final avg = db.sql.books.getAverageReadingTime();

    return Scaffold(
      body: ListView(
        children: [
          const WeeklyBar(),
          // const CategoriesLevel(),
          StatisticBar(
            statisticName: "Streak",
            valueName: "$streak",
            icon: IconImage(
              iconName: 'fire-flame.png',
            ),
          ),
          // topHabit.length > 0
          //     ? StatisticBar(
          //         statisticName: "Top Habit",
          //         valueName: "${topHabit[0]?['Name']}",
          //         icon: Text("${topHabit[0]?['Total']} Times"),
          //       )
          //     : const SizedBox(),
          // topGift.length > 0
          //     ? StatisticBar(
          //         statisticName: "Top Gift",
          //         valueName: "${topGift[0]['Name']}",
          //         icon: Text("${topGift[0]['Total']} Times"),
          //       )
          //     : const SizedBox(),
          topDay.length > 0
              ? StatisticBar(
                  statisticName: "Top Day",
                  valueName: "${topDay[0]['date']}",
                  icon: Text(minLabel( topDay[0]['Total'])),
                )
              : const SizedBox(),
              avg!= 0
              ? StatisticBar(
                  statisticName: "Top Day",
                  valueName: "Average reading time",
                  icon: Text(minLabel( avg)),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

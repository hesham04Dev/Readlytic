
import 'package:flutter/material.dart';

import '../../../../db/db.dart';
import '../../../../fn/time_lable.dart';
import '../../../../widgets/imageIcon.dart';

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
          topDay?.isNotEmpty??false
              ? StatisticBar(
                  statisticName: "Top Day",
                  valueName: "${topDay![0]['date']}",
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

import 'package:flutter/material.dart';

import '../../../../db/db.dart';
import '../../../../widgets/imageIcon.dart';
import 'widget/statisticBar.dart';
import 'widget/weeklyBar.dart';

class StatisticsBody extends StatelessWidget {
  const StatisticsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final topHabit = db.sql.books.getTop();
    final streak = db.sql.settings.getStreak();

    return Scaffold(
      body: ListView(
        children: [
          const WeeklyBar(),
          StatisticBar(
            statisticName: "Streak",
            valueName: "$streak",
            icon: IconImage(
              iconName: 'fire-flame.png',
            ),
          ),
          topHabit.isNotEmpty
              ? StatisticBar(
                  statisticName: "Top Habit",
                  valueName: "${topHabit[0]?['Name']}",
                  icon: Text("${topHabit[0]?['Total']} Times"),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

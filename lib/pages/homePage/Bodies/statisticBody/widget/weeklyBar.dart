
import 'package:flutter/material.dart';

import '../../../../../config/styles.dart';
import '../../../../../db/db.dart';

import '../../../../../fn/time_lable.dart';
import '../../../../../widgets/PrimaryContainer.dart';
import '../../../../../widgets/verticalBar.dart';

class WeeklyBar extends StatelessWidget {
  const WeeklyBar({super.key});

  //final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> x = db.sql.books.getWeeklyData();
    if (x.isNotEmpty) {
      double maxValue = 0;
      double avg = 0;
      for (int i = 0; i < x.length; i++) {
        if (x[i]['Total'] > maxValue) {
          maxValue = x[i]['Total'];
        }
        avg += x[i]['Total'];
      }
      avg = avg / x.length;
  print("max value is :$maxValue");

      return PrimaryContainer(
        padding: 0,
        opacity: 0.1,
        child: Column(
          children: [
            // Text(
            //   "Coins bar",
            //   style: titleStyle(context),
            // ),
            SizedBox(
              height: 210,
              child: ListView(
                  // physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: List.generate(
                    x.length,
                    (index) {
                      String date = x[index]["DateOnly"];
                      date = date.replaceFirst("-", " ");
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 20,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                VerticalBar(
                                  text: minLabel(x[index]['Total'].round()),
                                  filledHeight:
                                      120.0 * (x[index]['Total'].round() / maxValue),
                                  filledWidth: 25,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        minHeight: 1, minWidth: 1),
                                    child: Text(
                                      date,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 6.8,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ]),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      );
    } else {
      return const PrimaryContainer(
        opacity: 0.1,
        height: 150,
        child: Center(
          child: Text("do some habits to gather statistics on."),
        ),
      );
    }
  }
}


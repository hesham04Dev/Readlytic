import 'package:flutter/material.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    /*var habits = db.sql.habits.getArchived();
    var gifts = db.sql.gifts.getArchived();
    StatelessWidget habitsData;
    StatelessWidget giftsData;
    if (db.sql.settings.isListView()) {
      habitsData = ListView.builder(
        itemBuilder: (context, index) {
          return Habit.habitBuilder(context, habits[index]);
        },
        itemCount: habits.length,
      );
      giftsData = ListView.builder(
          itemBuilder: (context, index) {
            return Gift.giftBuilder(context, gifts[index]);
          },
          itemCount: gifts.length);
    } else {
      habitsData = MyGridView(
          itemBuilder: (context, index) {
            return Habit.habitBuilder(context, habits[index]);
          },
          itemCount: habits.length);
      giftsData = MyGridView(
          itemBuilder: (context, index) {
            return Gift.giftBuilder(context, gifts[index]);
          },
          itemCount: gifts.length);
    }*/
    //TODO
    return Scaffold(
      body: ListView(),
    );
  }
}

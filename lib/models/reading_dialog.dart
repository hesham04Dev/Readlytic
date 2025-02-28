import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/db.dart';
import '../pages/AddNewPages/widget/NumericField.dart';
import '../rootProvider/bookProvider.dart';

class ReadingDialog extends StatelessWidget {

  ReadingDialog({super.key,required this.bookId});
  final int  bookId;
  final TimerText timer = TimerText();
  int readPages = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var pagesField = NumericField(
                onChanged: (value) {
                  readPages = int.tryParse(value) ?? 0;
                },
                hintText: "Pages",
                maxValue: 100000,
              );
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              timer,
              SizedBox(
                width: 200,
                child: pagesField,
              ),
              FilledButton(
                  onPressed: () {
                    print("current time in timer is:${timer.getTime()}");

                    // update the data in the db
                    // call the provider
                    // pagesField.validate();
                    _formKey.currentState?.validate();
                    if(readPages > 0){
                      db.sql.books.addReading(bookId: bookId, readPages:readPages,time:timer.getTime());
                      context.read<BookProvider>().bookUpdated();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }

                  },
                  child: Text("close"))
              // Timer
              // readpages
              // close btn
            ],
          ),
        ),
      ),
    );
  }
}

class TimerText extends StatefulWidget {
  TimerText({Key? key}) : super(key: key);
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  int getTime() {
    return (seconds / 60).round() + minutes + hours * 60;
  }

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        widget.seconds++;
        if (widget.seconds == 60) {
          widget.seconds = 0;
          widget.minutes++;
        }
        if (widget.minutes == 60) {
          widget.minutes = 0;
          widget.hours++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${widget.hours.toString().padLeft(2, '0')}:"
      "${widget.minutes.toString().padLeft(2, '0')}:"
      "${widget.seconds.toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/duration_picker_dialog.dart' ;
import '/db/db.dart';
import '/pages/AddNewPages/widget/NumericField.dart';
import '/rootProvider/bookProvider.dart';
import '/widgets/PrimaryContainer.dart';
import '/widgets/animated_circular_container.dart';

class ReadingPage extends StatefulWidget {
  final int bookId;

  const ReadingPage({super.key, required this.bookId});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pageController = TextEditingController();
  int readPages = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool isRunning = false;
  Timer? _timer;
  double defaultMinutesPerPage = 1.5;
  late AnimationController _animController;
  late AnimatedCircularController _animatedCircularController;
  late Animation<double> _fadeIn;
  late Animation<double> _opacityAnim;
  int get totalTime => hours * 60 + minutes + (seconds >= 30 ? 1 : 0);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _opacityAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _animController.forward();
    _animatedCircularController = AnimatedCircularController();
    _animatedCircularController.stop();
  }

  void toggleTimer() {
    if (isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          seconds++;
          if (seconds == 60) {
            seconds = 0;
            minutes++;
          }
          if (minutes == 60) {
            minutes = 0;
            hours++;
          }
        });
      });
    }
    setState(() => isRunning = !isRunning);
    if (isRunning) {
      _animatedCircularController.start();
    } else {
      _animatedCircularController.stop();
    }
  }

  void useDefaultTime() {
    readPages = int.tryParse(_pageController.text) ?? 0;
    final totalMinutes = (readPages * defaultMinutesPerPage).round();
    setState(() {
      hours = totalMinutes ~/ 60;
      minutes = totalMinutes % 60;
      seconds = 0;
    });
  }

  void pickDuration() async {
    final Duration? picked = await showDialog<Duration>(
      context: context,
      builder: (_) => const DurationPickerDialog(),
    );
    if (picked != null) {
      setState(() {
        hours = picked.inHours;
        minutes = picked.inMinutes % 60;
        seconds = picked.inSeconds % 60;
      });
    }
  }

  void submitReading() async {
    _formKey.currentState?.validate();
    readPages = int.tryParse(_pageController.text) ?? 0;
    if (readPages > 0) {
      await db.sql.books.addReading(
        bookId: widget.bookId,
        readPages: readPages,
        time: totalTime,
      );
      context.read<BookProvider>().bookUpdated();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleTimer,
      onDoubleTap: pickDuration,
      child: Scaffold(
        // backgroundColor: Colors.indigo.shade50,
        appBar: AppBar(title: const Text("Reading Tracker")),
        body: FadeTransition(
          opacity: _fadeIn,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Tip: Tap to pause/resume timer, double tap to set time manually.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  Center(
                    
                    child: AnimatedBuilder(
                      animation: _opacityAnim,
                      builder: (context, child) => Opacity(
                        opacity: _opacityAnim.value,
                        child: AnimatedCircularContainer(
                          startStopped: true,
                          controller: _animatedCircularController ,
                            width: 200,
                            height: 200,
                            child: AnimatedScale(
                              scale: isRunning ? 1.3 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.indigo,
                                ),
                              ),
                            )),
                        
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  const Spacer(),
                  PrimaryContainer(
                    margin: 0,
                    padding: 4,
                    child: Row(
                      // alignment: Alignment.center,
                      children: [
                        Expanded(
                          child: NumericField(
                            controller: _pageController,
                            hintText: "Pages Read",
                            maxValue: 100000,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: useDefaultTime,
                          icon: const Icon(Icons.timer_outlined),
                          label: const Text("Default Time"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PrimaryContainer(
                    margin: 0,
                    padding: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: submitReading,
                            child: const Text("Save"),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.red)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

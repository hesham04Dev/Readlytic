

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DurationPickerDialog extends StatefulWidget {
  const DurationPickerDialog({super.key});

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Duration"),
      content: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Hours"),
                SizedBox(
                  height: 100,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (val) => hours = val,
                    children:
                        List.generate(24, (i) => Center(child: Text("$i"))),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Minutes"),
                SizedBox(
                  height: 100,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (val) => minutes = val,
                    children:
                        List.generate(60, (i) => Center(child: Text("$i"))),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Seconds"),
                SizedBox(
                  height: 100,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (val) => seconds = val,
                    children:
                        List.generate(60, (i) => Center(child: Text("$i"))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context,
              Duration(hours: hours, minutes: minutes, seconds: seconds)),
          child: const Text("OK"),
        )
      ],
    );
  }
}
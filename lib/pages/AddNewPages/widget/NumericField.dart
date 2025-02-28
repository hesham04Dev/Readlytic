
import 'package:flutter/material.dart';

import '../../../models/PrimaryContainer.dart';

class NumericField extends StatelessWidget {
  const NumericField(
      {super.key,
      this.controller,
      this.onChanged,
      required this.hintText,
      required this.maxValue});
  final TextEditingController? controller;
  final int maxValue;
  final Function(String)? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      paddingHorizontal: 20,
      padding: 0,
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(),
        validator: (value) {
          int val = int.tryParse(value ?? "0")??0;
          if (value == null || value.isEmpty) {
            return "please enter a number";
          } else if (val > maxValue) {
            return "value must be less than $maxValue";
          } else if (val < 0) {
            return "value must be greater than 0";
          }
          return null;
        },
        onChanged:onChanged,
        decoration:
            InputDecoration(hintText: hintText, border: InputBorder.none),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../widgets/PrimaryContainer.dart';

class NumericField extends StatelessWidget {
  const NumericField(
      {super.key,
      this.controller,
      this.onChanged,
      this.validate = true,
      this.showLabel = false,
      required this.hintText,
      required this.maxValue});
  final TextEditingController? controller;
  final int maxValue;
  final Function(String)? onChanged;
  final String hintText;
  final bool validate;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      paddingHorizontal: 20,
      padding: 0,
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(),
        validator: (value) {
          int val = int.tryParse(value ?? "0") ?? 0;
          if (value == null || value.isEmpty) {
            return validate ? "please enter a number" : null;
          } else if (val > maxValue) {
            return "value must be less than $maxValue";
          } else if (val < 0) {
            return "value must be greater than 0";
          }
          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
            label: showLabel ? Text(hintText) : null,
            hintText: hintText,
            labelStyle: const TextStyle(fontSize: 14),
            border: InputBorder.none),
      ),
    );
  }
}

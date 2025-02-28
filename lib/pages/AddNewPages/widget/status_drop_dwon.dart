import 'package:flutter/material.dart';
import 'package:sqlite3/common.dart';

import '../../../db/db.dart';
import '../../../models/PrimaryContainer.dart';


// ignore: must_be_immutable
class StatusDropDown extends StatefulWidget {
  final TextEditingController controller;
  StatusDropDown({super.key, required this.controller, this.selectedId=0});
  int selectedId;

  @override
  State<StatusDropDown> createState() => _StatusDropDownState();
}

class _StatusDropDownState extends State<StatusDropDown> {
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry> statusList = [];
    ResultSet result = db.sql.statuses.get();
    if(widget.selectedId == 0){
      widget.selectedId = result[0]['id'];
      widget.controller.text = result[0]['name'];
    }else{
      widget.controller.text = result.firstWhere((element) => element['id'] == widget.selectedId)['name'];
    }
    for (var row in result) {
      statusList.add(DropdownMenuEntry(value: row['id'], label: row['name']));
    }
    return PrimaryContainer(
      padding: 0,
      width: 150,
      height: 50,
      paddingHorizontal: 10,
      child: DropdownMenu(
          width: 130,
          controller: widget.controller,
          onSelected: (value) {
            widget.selectedId = value;
            setState(() {
              
            });
          },
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
          hintText: "Status",
          label: const Text(
            "Status",
            style: TextStyle(fontSize: 14),
          ),
          dropdownMenuEntries: statusList),
    );
  }
}

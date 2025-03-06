import 'package:flutter/material.dart';
import 'package:sqlite3/common.dart';

import '../../../db/db.dart';
import '../../../widgets/PrimaryContainer.dart';

class StatusDropDown extends StatefulWidget {
  int selectedId;
  StatusDropDown({super.key, this.selectedId = 0});

  @override
  State<StatusDropDown> createState() => _StatusDropDownState();
}

class _StatusDropDownState extends State<StatusDropDown> {
  // late int selectedId;
  List<DropdownMenuItem<int>> statusList = [];

  @override
  void initState() {
    super.initState();
    
    _loadStatuses();
  }

  void _loadStatuses() {
    ResultSet result = db.sql.statuses.get();
    
    if (result.isEmpty) return; // Ensure there's data

    statusList = result.map((row) {
      return DropdownMenuItem<int>(value: row['id'], child: Text(row["name"]),);
    }).toList();

    // Set default selected ID if it's 0 or not found in the list
    widget.selectedId = result.any((row) => row['id'] == widget.selectedId)
        ? widget.selectedId
        : result[0]['id'];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      padding: 0,
      width: 130,
      height: 50,
      paddingHorizontal: 10,
      child: DropdownButton<int>(
        value: widget.selectedId,
        hint:  const Text(
          "Status",
          style: TextStyle(fontSize: 14),
        ),
        // width: 130,
        // controller: widget.controller,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              widget.selectedId = value;
              // widget.controller.text = statusList
              //     .firstWhere((entry) => entry.value == value)
              //     .key;
            });
          }
        },
        // inputDecorationTheme: const InputDecorationTheme(
        //   border: InputBorder.none,
        // ),
        // hintText: "Status",
        // label: const Text(
        //   "Status",
        //   style: TextStyle(fontSize: 14),
        // ),
        // dropdownMenuEntries: statusList,
        borderRadius: BorderRadius.circular(25),
        elevation: 0,
        underline: const SizedBox(),
        focusColor: Colors.transparent,
        items: statusList,
        
      ),
    );
  }
 

}

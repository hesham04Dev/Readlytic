import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../NewBook/new_book.dart';
import '../Bodies/providers/pageIndexProvider.dart';

class MyFab extends StatelessWidget {
  const MyFab({super.key});

  @override
  Widget build(BuildContext context) {
    int pageIndex = context.watch<PageIndexProvider>().pageIndex;
    if (pageIndex == 0 || pageIndex == 3) {
      return const SizedBox();
    } else {
      return FloatingActionButton(
          heroTag: "add",
          elevation: 0,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const NewBook();
            }));
          },
          child: const Icon(
            Icons.add_rounded,
            size: 25,
            color: Colors.white54,
          ));
    }
  }
}

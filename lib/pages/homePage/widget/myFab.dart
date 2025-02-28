
import 'package:asset_icon/asset_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../AddNewPages/new_book.dart';
import '../Bodies/providers/pageIndexProvider.dart';

class MyFab extends StatelessWidget {
  const MyFab({super.key});

  @override
  Widget build(BuildContext context) {
    int pageIndex = context.watch<PageIndexProvider>().pageIndex;
    if (pageIndex != 1) {
      return const SizedBox();
    } else {
      return FloatingActionButton(
          heroTag: "add",
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return  NewBookPage();
            }));
          },
          child:  AssetIcon(
            "add.svg",
            size: 35,
            // color: Colors.black,
          ));
    }
  }
}

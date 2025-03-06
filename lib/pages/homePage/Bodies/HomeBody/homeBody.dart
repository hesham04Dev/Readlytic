import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/PrimaryContainer.dart';
import '../../../../widgets/book.dart';
import '../../../../rootProvider/bookProvider.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    var books = context.watch<BookProvider>().Books;
    return Column(
      children: [
        Expanded(
          child: PrimaryContainer(
            opacity: 0.1,
            child:  ListView.builder(
                    itemBuilder: (child, index) =>
                        Book.builder(context, books[index]),
                    itemCount: books?.length??0,
                    shrinkWrap: false,
                  )
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/PrimaryContainer.dart';
import '../../../../rootProvider/books_provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    var books = context.watch<BooksProvider>().books;
    return Column(
      children: [
        Expanded(
          child: PrimaryContainer(
              opacity: 0.1,
              child: ListView.builder(
                itemBuilder: (child, index) {},
                itemCount: books.length,
                shrinkWrap: false,
              )),
        ),
      ],
    );
  }
}

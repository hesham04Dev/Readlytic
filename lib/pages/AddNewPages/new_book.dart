import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/const.dart';
import '../../db/db.dart';
import '../../widgets/AutoDirectionTextFormField.dart';
import '../../widgets/book.dart';
import '../../rootProvider/bookProvider.dart';
import 'widget/NumericField.dart';
import 'widget/status_drop_dwon.dart';

// ignore: must_be_immutable
class NewBookPage extends StatefulWidget {
  NewBookPage({super.key, this.title = "New Book"});
  List<Widget>? actions;
  final String title;
  static const int gearIconId = 39;

  @override
  State<NewBookPage> createState() => NewBookPageState();
}

class NewBookPageState extends State<NewBookPage> {
  // final double rating;TODO

  late final TextEditingController title;
  late final TextEditingController currentPage;
  late final TextEditingController totalPages;
  late final TextEditingController author;
  late final TextEditingController categories;
  // late final TextEditingController status;
  late final TextEditingController notes;
  late final TextEditingController averageReadingTime;
  late final GlobalKey<FormState> formKey;
  late StatusDropDown statusDropDown;

  // late SelectIcon selectIcon;
  List<Widget>? children;

  void save(BuildContext context) {
    if (formKey.currentState!.validate()) {
      Book newBook = Book(
        id: 0,
        title: title.text,
        author: author.text,
        totalPages: int.tryParse(totalPages.text) ?? 0,
        currentPage: int.tryParse(currentPage.text) ?? 0,
        averageReadingTime:
            double.tryParse(averageReadingTime.text) ?? kDefaultAvgReadingTime,
        rating: 0,
        categories: categories.text,
        statusId: statusDropDown.selectedId,
        notes: notes.text,
        readingCount: 0,
      );
      db.sql.books.add(newBook);
      // db.sql.books.add(
      //     name: name.text,
      //     categoryId: categoryDropDown.selectedId,
      //     isBad: isBad.value,
      //     price: int.parse(coins.text),
      //     iconId: selectIcon.selectedIconId ?? NewBookPage.gearIconId,
      //     priority: priority.selected,
      //     hardness: hardness.selected,
      //     timeInMinutes: int.parse(time.text));
      // TODO

      context.read<BookProvider>().newBook();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    title = TextEditingController();
    currentPage = TextEditingController();
    totalPages = TextEditingController();
    categories = TextEditingController();

    author = TextEditingController();
    // status = TextEditingController();
    notes = TextEditingController();
    averageReadingTime = TextEditingController();
    formKey = GlobalKey<FormState>();

    statusDropDown = StatusDropDown();

    // Listen to totalPages and update currentPage field when it changes
    totalPages.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    AutoDirectionTextFormField(
                        showLabel: true,
                        controller: title,
                        errMessage: "please enter a title",
                        hintText: "title"),
                    AutoDirectionTextFormField(
                        showLabel: true,
                        controller: author,
                        hintText: "author"),
                    AutoDirectionTextFormField(
                        showLabel: true,
                        controller: categories,
                        hintText: "categories"),
                    Row(
                      children: [
                        Expanded(
                          child: NumericField(
                            showLabel: true,
                            controller: averageReadingTime,
                            hintText: "avg min/page",
                            maxValue: 100000,
                            validate: false,
                          ),
                        ),
                        statusDropDown,
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: NumericField(
                            showLabel: true,
                            controller: totalPages,
                            hintText: "total Pages",
                            maxValue: 100000,
                          ),
                        ),
                        Expanded(
                          child: NumericField(
                            showLabel: true,
                            controller: currentPage,
                            hintText: "current page",
                            validate: false,
                            maxValue: int.tryParse(totalPages.text) ?? 0,
                          ),
                        ),
                      ],
                    ),
                    AutoDirectionTextFormField(
                      showLabel: true,
                      controller: notes,
                      hintText: "notes",
                      maxLines: 3,
                    ),
                    ...?children,
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        save(context);
                      },
                      child: const Text("save"),
                      //color: Theme.of(context).primaryColor.withOpacity(0.5),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    title.dispose();
    currentPage.dispose();
    totalPages.dispose();
    author.dispose();
    categories.dispose();
    // status.dispose();
    notes.dispose();
    averageReadingTime.dispose();
    super.dispose();
  }
}

// TODO add rating bar

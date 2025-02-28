
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../db/db.dart';
import '../../models/AutoDirectionTextFormField.dart';
import '../../models/book.dart';
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
  late final TextEditingController status;
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
        averageReadingTime: double.tryParse(averageReadingTime.text) ?? 0,
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
    status = TextEditingController();
    notes = TextEditingController();
    averageReadingTime = TextEditingController();
    formKey = GlobalKey<FormState>();

    statusDropDown = StatusDropDown(
      controller: status,
    );

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
                        controller: title,
                        errMessage: "please enter a title",
                        hintText: "title"),
                    AutoDirectionTextFormField(
                        controller: author,
                        errMessage: "please enter an author",
                        hintText: "author"),
                    AutoDirectionTextFormField(
                        controller: categories,
                        errMessage: "please enter the categories",
                        hintText: "categories"),
                    AutoDirectionTextFormField(
                        controller: notes,
                        errMessage: "please enter your note",
                        hintText: "notes"),
                    statusDropDown,
                    NumericField(
                      controller: averageReadingTime,
                      hintText: "Average Reading Time",
                      maxValue: 100000,
                    ),
                    NumericField(
                      controller: totalPages,
                      hintText: "total Pages",
                      maxValue: 100000,
                    ),
                    NumericField(
                      controller: currentPage,
                      hintText: "current page",
                      maxValue: int.tryParse(totalPages.text) ?? 0,
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
    status.dispose();
    notes.dispose();
    averageReadingTime.dispose();
    super.dispose();
  }
}

// TODO add rating bar

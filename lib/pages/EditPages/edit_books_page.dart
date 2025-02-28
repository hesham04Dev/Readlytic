
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/db.dart';

import '../../models/book.dart';
import '../../models/reading_dialog.dart';
import '../../rootProvider/bookProvider.dart';
import '../AddNewPages/new_book.dart';

class EditBooksPage extends NewBookPage {
  final Book book;

  EditBooksPage({super.key, required this.book, super.title = "Edit Book"});

  @override
  // ignore: no_logic_in_create_state
  State<NewBookPage> createState() => _EditBookPageState(book: book);
}

class _EditBookPageState extends NewBookPageState {
  final Book book;
  _EditBookPageState({required this.book});
  @override
  void initState() {
    super.initState();
    super.title.text = book.title;
    // final double rating;TODO



    super.currentPage.text = book.currentPage.toString();
    super.totalPages.text =  book.totalPages.toString();
    super.author.text = book.author;
    super.categories.text = book.categories;
    super.status.text = db.sql.statuses.getById(book.statusId)['name'].toString(); // check if it correct
    super.notes.text = book.notes;
    super.averageReadingTime.text = book.averageReadingTime.toString();

    // super.category.text =
    //     "${db.sql.categories.getById(habit.categoryId)['Name']}";
    super.statusDropDown.selectedId = book.statusId;
  //   super.statusDropDown = CategoryDropDown(
  //   controller: super.status,

  // );
  print("status id ${book.statusId}");
  print("status name ${super.status.text}");
    // TODO dropdown dont take the val
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

      actions = [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: IconButton(
        //       onPressed: () {
        //         db.sql.habits.archive(id: habit.id);
        //         context.read<HabitProvider>().habitUpdated();
        //         Navigator.pop(context);
        //       },
        //       icon: IconImage(iconName: "box-archive.png")),
        // )
      ];

    widget.actions = actions;
    super.children = [
      // PrimaryContainer(
      //     child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     TextButton(
      //         onPressed: () {
      //           if (habit.totalTimes > 0) {
      //             habit.undo();
      //           }
      //           setState(() {});
      //         },
      //         child: const Text("-")),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //       child: Text(habit.totalTimes.toString()),
      //     ),
      //     TextButton(
      //         onPressed: () {
      //           habit.clicked();
      //           setState(() {});
      //         },
      //         child: const Text("+"))
      //   ],
      // ))


      FilledButton(onPressed: (){
        showDialog(context: context,barrierDismissible: false, builder: (context) => ReadingDialog(bookId: book.id,));
      }, child: const Text("Start Reading")),
    ];
    return super.build(context);
  }

  @override
  void save(BuildContext context) {
    if (super.formKey.currentState!.validate()) {
      Book b = Book(
        id: book.id,
        title: super.title.text,
        statusId: super.statusDropDown.selectedId,

        currentPage: int.parse(super.currentPage.text),
        totalPages: int.parse(super.totalPages.text),
        averageReadingTime: double.parse(super.averageReadingTime.text), author: super.author.text,
        rating: 0,//TODO
        categories: super.categories.text,
        notes: super.notes.text,
        readingCount: 0 // TODO get it from the db,

        // context: context,

      );
      db.sql.books.update(b);
      context.read<BookProvider>().bookUpdated();
      Navigator.pop(context);
    }
  }
}

// TODO Add the timer box


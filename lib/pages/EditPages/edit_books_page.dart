import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/config/const.dart';
import '/pages/AddNewPages/widget/status_drop_dwon.dart';
import '/pages/reading_page.dart';
import '/pages/AddNewPages/new_book.dart';
import '/db/db.dart';
import '/widgets/book.dart';
import '/rootProvider/bookProvider.dart';


class EditBooksPage extends NewBookPage {
  final Book book;

  EditBooksPage({super.key, required this.book, super.title = "Edit Book"});

  @override
  // ignore: no_logic_in_create_state
  State<EditBooksPage> createState() => _EditBookPageState(/*book: book*/);
}

class _EditBookPageState extends NewBookPageState {
  // final Book book;
  // _EditBookPageState({required this.book});
  @override
  void initState() {
    super.initState();
    super.title.text = widget.book.title;
    // final double rating;TODO

    super.currentPage.text = widget.book.currentPage.toString();
    super.totalPages.text = widget.book.totalPages.toString();
    super.author.text = widget.book.author;
    super.categories.text = widget.book.categories;
    // super.status.text = db.sql.statuses.getById(book.statusId)['name'].toString(); // check if it correct
    super.notes.text = widget.book.notes;
    super.averageReadingTime.text = widget.book.averageReadingTime.toString();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    setState(() {
      super.statusDropDown = StatusDropDown(
        // controller: super.status,
        selectedId: widget.book.statusId,
      );
    });

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

      // FilledButton(onPressed: (){
      //   showDialog(context: context,barrierDismissible: false, builder: (context) => ReadingDialog(bookId: widget.book.id,));
      // }, child: const Text("Start Reading")),

      FilledButton(
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => ReadingPage(
                      bookId: widget.book.id,
                    ));
          },
          child: const Text("Start Reading")),
    ];
    return super.build(context);
  }

  @override
  void save(BuildContext context) {
    if (super.formKey.currentState!.validate()) {
      print(super.statusDropDown.selectedId);
      print(55);
      Book b = Book(
          id: widget.book.id,
          title: super.title.text,
          statusId: super.statusDropDown.selectedId,
          currentPage: int.tryParse(super.currentPage.text) ?? 0,
          totalPages: int.parse(super.totalPages.text),
          averageReadingTime: double.tryParse(super.averageReadingTime.text) ??
              kDefaultAvgReadingTime,
          author: super.author.text,
          rating: 0, //TODO
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


import 'package:asset_icon/asset_icon.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../pages/EditPages/edit_books_page.dart';
import 'PrimaryContainer.dart';
import 'chartBar.dart';

class Book extends StatelessWidget {
  static const width = 110;
  final int id;
  final String title;
  final String author;
  final int totalPages;
  final int currentPage;
  final double averageReadingTime;
  final double rating;
  final String categories;
  final int statusId;
  final String notes;
  final int readingCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO open edit_add book page
        // TODO we need to manage the percentage of the book read in provider
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return EditBooksPage(
            book: this,
          );
        }));
      },
      child: PrimaryContainer(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            AssetIcon(
              "book.svg",
              size: 35,
            ),
            const SizedBox(
                width: 10), // Add spacing instead of padding in Flexible
            Expanded(
              // Use Expanded instead of Flexible
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ChartBar(
                      text: "page: $currentPage",
                      percent: currentPage / totalPages,
                      size: 200,
                      thickness: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                width: 10), // Ensure spacing before pushing items apart
          ],
        ),
      )),
    );
  }

  const Book({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    required this.totalPages,
    required this.currentPage,
    required this.averageReadingTime,
    required this.rating,
    required this.categories,
    required this.statusId,
    required this.notes,
    required this.readingCount,
  });
  static Widget builder(context, book) {
    return Book(
      // context: context,
      author: book['author'],
      averageReadingTime: book['average_reading_time'],
      categories: book['categories'],
      id: book['id'],
      title: book["title"],
      totalPages: book["total_pages"],
      currentPage: book["current_page"],
      rating: book["rating"],
      statusId: book["status_id"],
      notes: book["notes"],
      readingCount: book["reading_count"],
    );
  }
}

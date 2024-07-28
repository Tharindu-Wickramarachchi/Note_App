import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:note/models/note_model.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onPressed;

  const NoteCard({super.key, required this.note, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    DateTime displayTime = note.updatedAt.isAfter(note.createdAt)
        ? note.updatedAt
        : note.createdAt;
    // display format
    String formattedDateTime =
        DateFormat('h:mma MMMM d, y').format(displayTime);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Color(note.color),
          border: Border.all(
            color: Colors.black, // Border color
            width: 0.6, // Border width
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0, // Remove shadow to see the gradient better
          color: Colors
              .transparent, // Make the card transparent to see the gradient
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Html(
                          data: note.note, // HTML content
                          style: {
                            'body': Style(
                              color: Colors.black,
                              fontSize: FontSize(10),
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Text(
                      formattedDateTime,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

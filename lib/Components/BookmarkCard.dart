import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookmarkCard extends StatefulWidget {
  final Map<String, dynamic> quote;
  final String email;
  const BookmarkCard({
    super.key,
    required this.quote,
    required this.email,
  });

  @override
  State<BookmarkCard> createState() => _BookmarkCardState();
}

class _BookmarkCardState extends State<BookmarkCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 4,
            color: Colors.blue,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.quote['quote'],
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Author: ${widget.quote['author']}",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Date: ${widget.quote['createdAt']}",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Remove Bookmark",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("bookmarks")
                      .doc(widget.email)
                      .collection("userBookmarks")
                      .doc(widget.quote['quoteId'])
                      .delete();
                },
                icon: Icon(
                  Icons.bookmark,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

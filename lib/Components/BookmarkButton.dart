import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/quote.dart';

class BookMarkButton extends StatefulWidget {
  final Quote quote;
  final String email;
  const BookMarkButton({super.key, required this.quote, required this.email});

  @override
  State<BookMarkButton> createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends State<BookMarkButton> {
  bool _isBookmarked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchQuoteState();
  }

  void _fetchQuoteState() async {
    final quoteSnapshot = await FirebaseFirestore.instance
        .collection("bookmarks")
        .doc(widget.email)
        .collection("userBookmarks")
        .doc(widget.quote.quoteId)
        .get();

    if (quoteSnapshot.exists) {
      if (mounted) {
        setState(() {
          _isBookmarked = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isBookmarked = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: _isBookmarked
              ? Icon(
                  Icons.bookmark,
                  color: Colors.white,
                  size: 30,
                )
              : Icon(
                  Icons.bookmark_border_outlined,
                  color: Colors.white,
                  size: 30,
                ),
          onPressed: () async {
            //check if quote is already bookmarked or not
            final bookmarkDoc = await FirebaseFirestore.instance
                .collection("bookmarks")
                .doc(widget.email)
                .collection("userBookmarks")
                .doc(widget.quote.quoteId)
                .get();

            if (bookmarkDoc.exists) {
              //bookmark is already exist so delete the bookmark
              bookmarkDoc.reference.delete();
              if (mounted) {
                setState(() {
                  _isBookmarked = false;
                });
              }
            } else {
              bookmarkDoc.reference.set(widget.quote.toMap());
              if (mounted) {
                setState(() {
                  _isBookmarked = true;
                });
              }
            }
          },
        ),
      ],
    );
  }
}

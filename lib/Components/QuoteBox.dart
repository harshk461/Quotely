// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quotely/Components/BookmarkButton.dart';
import 'package:quotely/Components/likeButton.dart';

import '../model/quote.dart';

class QuoteCard extends StatefulWidget {
  final String quoteText;
  final String createdBy;
  final String datePosted;
  final String quoteId;
  final Quote quote;
  final String profileUrl;
  const QuoteCard({
    super.key,
    required this.quoteText,
    required this.createdBy,
    required this.datePosted,
    required this.quoteId,
    required this.quote,
    required this.profileUrl,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool _expanded = false;
  String email = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      email = FirebaseAuth.instance.currentUser!.email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                border: Border.all(
                  width: 5,
                  color: Colors.blue,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //quote text body
                Text(
                  widget.quoteText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Date Posted: ${widget.datePosted}",
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    LikeButton(quoteId: widget.quoteId, email: email),
                    BookMarkButton(quote: widget.quote, email: email),
                  ],
                )
              ],
            ),
          ),
        ),
        AnimatedContainer(
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20),
          ),
          width: _expanded ? (double.maxFinite) : 0,
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 20),
          duration: Duration(milliseconds: 300),
          height: _expanded ? 80 : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Container(
              //   height: 90,
              //   width: 90,
              //   child: CircleAvatar(
              //     backgroundColor: Colors.blueGrey,
              //     backgroundImage: (widget.profileUrl.isNotEmpty &&
              //             widget.quote.email ==
              //                 FirebaseAuth.instance.currentUser!.email)
              //         ? NetworkImage(widget.profileUrl)
              //         : null,
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Created By",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.createdBy,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 88, 87, 87)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

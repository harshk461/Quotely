// ignore_for_file: file_names
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quotely/Pages/Home.dart';
import 'package:quotely/model/quote.dart';
import '../Components/LabelInputBox.dart';

class PostQuote extends StatefulWidget {
  const PostQuote({super.key});

  @override
  State<PostQuote> createState() => _PostQuoteState();
}

class _PostQuoteState extends State<PostQuote> {
  TextEditingController _quote = TextEditingController();
  TextEditingController _author = TextEditingController();
  TextEditingController _tags = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // bottomNavigationBar: BottomBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
          child: Icon(Icons.home),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //app bar
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Post Quote",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        post_quote();
                      },
                      icon: Icon(Icons.add),
                      label: Text(
                        "Post",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Post Quote Body
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    child: Image(
                      image: AssetImage("assets/images/quote.png"),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  LabelInputBox(
                    controller: _quote,
                    placeholder: "Quote",
                    maxLines: 4,
                    minLines: 3,
                  ),
                  LabelInputBox(
                    controller: _author,
                    placeholder: "Author Name",
                    maxLines: 1,
                    minLines: 1,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 219, 212, 212),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    child: TextField(
                      minLines: 3,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _tags,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Tags (Write comma separated values)",
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateQuoteId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final length = random.nextInt(5) + 8;
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  Future post_quote() async {
    //split tags
    String cleanText = _tags.text.replaceAll(RegExp(r'[^\w\s,]'), '');

    List<String> tags = cleanText.toString().split(',');
    final String customId = generateQuoteId();
    Quote newQuote = Quote(
      author: _author.text,
      quote: _quote.text,
      tags: tags,
      email: FirebaseAuth.instance.currentUser!.email.toString(),
      createdAt: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      quoteId: customId,
      likes: 0,
    );
    Map<String, dynamic> quote = newQuote.toMap();
    try {
      await FirebaseFirestore.instance
          .collection("quotes")
          .doc(customId)
          .set(quote);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } catch (e) {
      print(e);
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error Occured")));
    }
  }
}

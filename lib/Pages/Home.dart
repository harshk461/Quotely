import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quotely/Components/QuoteBox.dart';
import 'package:quotely/Pages/Bookmark.dart';
import 'package:quotely/Pages/Login.dart';
import 'package:quotely/Pages/OwnQuotes.dart';
import 'package:quotely/Pages/PostQuote.dart';
import 'package:quotely/Pages/Profile.dart';
import 'package:quotely/Pages/SignUp.dart';

import '../model/quote.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Quote> quotes = [];
  bool isLoading = false;
  String profileUrl = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileUrl();
    fetchQuotes();
  }

  void getProfileUrl() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((queysnapshot) {
      print(queysnapshot.docs[0].data()['profile_image_url']);
      if (mounted) {
        setState(() {
          profileUrl = queysnapshot.docs[0].data()['profile_image_url'];
        });
      }
    });
  }

  Future<void> fetchQuotes() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await FirebaseFirestore.instance
        .collection('quotes')
        .orderBy("created_At", descending: true)
        .get()
        .then((querySnapshot) {
      List<Quote> quotes = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // process the data here
        Quote quote = Quote.fromMap(data);
        quotes.add(quote);
      });
    });

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              //App bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      icon: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),

              //Navigation bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  // scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PostQuote()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7, top: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  )),
                              child: const Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Add Quote",
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BookmarkScreen()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7, top: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  )),
                              child: const Icon(
                                Icons.bookmark,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Saved",
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Profile()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7, top: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  )),
                              child: const Icon(
                                Icons.person_2_rounded,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Profile",
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OwnQuotes()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7, top: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  )),
                              child: const Icon(
                                Icons.favorite,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Own Quotes",
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 7, top: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black,
                                  )),
                              child: const Icon(
                                Icons.how_to_reg,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Sign Up",
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Quote Body
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Recent Quotes...",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("quotes")
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      Quote quote = Quote.fromMap(data);
                      return QuoteCard(
                        quoteText: quote.quote,
                        createdBy: quote.author,
                        datePosted: quote.createdAt,
                        quoteId: quote.quoteId,
                        profileUrl: profileUrl,
                        quote: quote,
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

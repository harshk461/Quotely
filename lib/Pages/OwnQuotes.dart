import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quotely/Components/Loader.dart';
import 'package:quotely/Components/OwnQuoteCard.dart';
import 'package:quotely/Components/QuoteBox.dart';
import 'package:quotely/Pages/Home.dart';
import 'package:quotely/model/quote.dart';

class OwnQuotes extends StatefulWidget {
  const OwnQuotes({super.key});

  @override
  State<OwnQuotes> createState() => _OwnQuotesState();
}

class _OwnQuotesState extends State<OwnQuotes> {
  String _email = '';
  bool _isLoading = false;
  List<Map<String, dynamic>> own_quote_data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentEmail();
  }

  void getCurrentEmail() {
    if (mounted) {
      setState(() {
        _email = FirebaseAuth.instance.currentUser!.email.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                //app bar
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()));
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const Text(
                            "Own Quotes",
                            style: TextStyle(
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("quotes")
                        .where("email", isEqualTo: _email)
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
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          Quote quote = Quote.fromMap(data);
                          return OwnQuoteCard(quote: quote);
                        },
                      );
                    },
                  )
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemCount: 2,
                  //     itemBuilder: (context, index) =>
                  //         Text(own_quote_data[index]['quote']))
                  // ElevatedButton(
                  //     onPressed: () {
                  //     },
                  //     child: Text("jsmd")),
                ],
              ),
            ),
            _isLoading ? Loader() : Container(),
          ],
        ),
      ),
    );
  }
}

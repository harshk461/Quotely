import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/quote.dart';

class LikeButton extends StatefulWidget {
  final String quoteId;
  final String email;

  LikeButton({required this.quoteId, required this.email});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _getLikeData();
  }

  Future<void> _getLikeData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('liked_quotes')
        .where('quote_id', isEqualTo: widget.quoteId)
        .get();
    if (mounted) {
      setState(() {
        _likeCount = snapshot.docs.length;
        _isLiked = snapshot.docs.any((doc) => doc['email'] == widget.email);
      });
    }
  }

  Future<void> _likeQuote() async {
    await FirebaseFirestore.instance.collection('liked_quotes').add({
      'quote_id': widget.quoteId,
      'email': widget.email,
    });
    if (mounted) {
      setState(() {
        _isLiked = true;
        _likeCount++;
      });
    }
  }

  Future<void> _unlikeQuote() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('liked_quotes')
        .where('quote_id', isEqualTo: widget.quoteId)
        .where('email', isEqualTo: widget.email)
        .get();
    final docId = snapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('liked_quotes')
        .doc(docId)
        .delete();
    if (mounted) {
      setState(() {
        _isLiked = false;
        _likeCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: _isLiked
              ? Icon(
                  Icons.favorite,
                  color: Colors.pink,
                  size: 30,
                )
              : Icon(
                  Icons.favorite_border,
                  color: Colors.pink,
                  size: 30,
                ),
          onPressed: () async {
            if (_isLiked) {
              await _unlikeQuote();
            } else {
              await _likeQuote();
            }
          },
          tooltip: _isLiked ? 'Unlike' : 'Like',
        ),
        Text(
          _likeCount.toString(),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    );
  }
}

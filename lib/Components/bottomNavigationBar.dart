import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:quotely/Pages/PostQuote.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.black,
        // borderRadius: BorderRadius.circular(30),
      ),
      child: GNav(
        backgroundColor: Colors.black,
        style: GnavStyle.google,
        color: Colors.white,
        activeColor: Colors.white,
        gap: 8,
        tabBackgroundColor: Colors.cyan.shade800,
        padding: const EdgeInsets.all(10),
        onTabChange: (value) {},
        tabs: [
          GButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => PostQuote()));
            },
            icon: Icons.create,
            text: "Post Quote",
            iconSize: 25,
            textStyle: TextStyle(
              fontSize: 17.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const GButton(
            icon: Icons.favorite_border,
            text: "Wishlist",
            iconSize: 25,
            textStyle: TextStyle(
              fontSize: 17.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const GButton(
            icon: Icons.person,
            text: "Profile",
            iconSize: 25,
            textStyle: TextStyle(
              fontSize: 17.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const GButton(
            icon: Icons.favorite_border,
            text: "Like",
            iconSize: 25,
            textStyle: TextStyle(
              fontSize: 17.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

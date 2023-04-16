// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quotely/Components/InputBox.dart';
import 'package:quotely/Components/Loader.dart';
import 'package:quotely/Pages/ForgotPassword.dart';
import 'package:quotely/Pages/Home.dart';
import 'package:quotely/Pages/SignUp.dart';
import 'package:video_player/video_player.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  late VideoPlayerController _controller;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("assets/video/login_bg.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized
        if (mounted) {
          setState(() {});
        }
      });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            width: 10,
                            color: Colors.blue,
                          )),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/login_logo.jpg"),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InputBox(
                      controller: _emailcontroller,
                      hiddenText: false,
                      placeholder: "Enter your Email...",
                    ),
                    InputBox(
                      controller: _passwordcontroller,
                      hiddenText: true,
                      placeholder: "Enter your Password...",
                    ),
                    Container(
                      width: 150.0,
                      height: 40.0,
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          sign_in();
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                      child: Text(
                        "Don't have an account? Sign Up Now",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _isLoading ? Loader() : Container(),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'\S+@\S+\.\S+').hasMatch(email);
  }

  Future sign_in() async {
    if (_emailcontroller.text.isEmpty || _passwordcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter All fields")));
    } else if (!isValidEmail(_emailcontroller.text.trim())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter Valid Mail")));
    } else {
      try {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }
        UserCredential user =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailcontroller.text.trim(),
          password: _passwordcontroller.text.trim(),
        );
        if (!FirebaseAuth.instance.currentUser!.emailVerified) {
          await user.user!.sendEmailVerification();
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Please verify Email first",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amberAccent,
          ));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } on FirebaseAuthException catch (ex) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        if (ex.code.toString() == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("User Not found"),
            backgroundColor: Colors.amberAccent,
          ));
        }
        if (ex.code.toString() == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong Password"),
            backgroundColor: Colors.amberAccent,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(ex.code.toString()),
            backgroundColor: Colors.amberAccent,
          ));
        }
      }
    }
  }
}

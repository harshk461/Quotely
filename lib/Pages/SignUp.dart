import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";
import 'package:intl/intl.dart';
import 'package:quotely/Components/Loader.dart';
import 'package:quotely/Components/InputBox.dart';
import 'package:quotely/Pages/Home.dart';
import 'package:quotely/Pages/Login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _cnfpassword = TextEditingController();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _bio = TextEditingController();
  TextEditingController _dob = TextEditingController();
  late File _imageFile;
  String _imageURL = '';
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    Reference ref = firebaseStorage
        .ref()
        .child("assets/images/${DateTime.now().toString()}");

    UploadTask uploadTask = ref.putFile(File(image!.path));

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    //app bar
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //back button
                          IconButton(
                            onPressed: () {
                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                            ),
                          ),
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            icon: const Icon(Icons.login),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Account detail container
                    Column(
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Account Details ",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InputBox(
                          controller: _username,
                          hiddenText: false,
                          placeholder: "Username",
                        ),
                        InputBox(
                          controller: _email,
                          hiddenText: false,
                          placeholder: "Email",
                        ),
                        InputBox(
                          controller: _password,
                          hiddenText: true,
                          placeholder: "Password",
                        ),
                        InputBox(
                          controller: _cnfpassword,
                          hiddenText: true,
                          placeholder: "Confirm Password",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    //Personal Detail Container
                    Column(
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Personal Details ",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InputBox(
                          controller: _firstname,
                          hiddenText: false,
                          placeholder: "First Name",
                        ),
                        InputBox(
                          controller: _lastname,
                          hiddenText: false,
                          placeholder: "Last Name",
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              )),
                          child: TextField(
                            autocorrect: false,
                            controller: _dob,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                print(pickedDate);
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                print(formattedDate);

                                setState(() {
                                  _dob.text = formattedDate;
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                            decoration: const InputDecoration(
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                icon: Icon(
                                    Icons.calendar_today), //icon of text field
                                labelText: "Enter Date" //label text of field
                                ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              )),
                          child: TextField(
                            minLines: 3,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            controller: _bio,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Bio...",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //submit button
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
                          sign_up();
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
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

  void reset() {
    setState(() {
      _username.text = '';
      _email.text = '';
      _password.text = '';
      _cnfpassword.text = '';
      _firstname.text = '';
      _lastname.text = '';
      _dob.text = '';
      _bio.text = '';
    });
  }

  bool isValidEmail(String email) {
    return RegExp(r'\S+@\S+\.\S+').hasMatch(email);
  }

  Future sign_up() async {
    if ((_username.text == '' || _username.text.isEmpty) ||
        (_email.text == '' || _email.text.isEmpty) ||
        (_password.text == '' || _password.text.isEmpty) ||
        (_cnfpassword.text == '' || _cnfpassword.text.isEmpty) ||
        (_firstname.text == '' || _firstname.text.isEmpty) ||
        (_lastname.text == '' || _lastname.text.isEmpty) ||
        (_bio.text == '' || _bio.text.isEmpty)) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter All fields",
          ),
        ),
      );
    } else if (_password.text != _cnfpassword.text) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password don't match",
          ),
        ),
      );
    } else if (!isValidEmail(_email.text.trim())) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter valid email",
          ),
        ),
      );
    }
    try {
      setState(() {
        _isLoading = true;
      });
      // create new user using firebase authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      userCredential.user!
          .updateDisplayName("${_firstname.text} ${_lastname.text}");
      // Generate unique document ID based on name and email
      String docId = "${_firstname.text}_${_email.text.replaceAll('.', '_')}";

      // Data
      Map<String, dynamic> userData = {
        "username": _username.text.trim(),
        "name": ("${_firstname.text} ${_lastname.text}"),
        "email": _email.text.trim(),
        "dob": _dob.text.trim(),
        "bio": _bio.text.trim(),
        "created_At": FieldValue.serverTimestamp(),
        "docId": docId,
        "profile_image_url": '',
      };

      //storing data in firebase firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(docId)
          .set(userData);

      //send email verification link
      await userCredential.user!.sendEmailVerification();

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email Verification link has been sent")));
      //sign out the current user
      await FirebaseAuth.instance.signOut();

      //after successFully storing data redirect to Login page
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      reset();
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message!,
          ),
        ),
      );
    }
  }
}

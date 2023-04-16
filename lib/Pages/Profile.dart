import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quotely/Components/Loader.dart';
import 'package:quotely/Components/ProfileRow.dart';
import 'Home.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late File _image;
  String _downloadUrl = '';
  String docID = '';
  late var userData;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfiledata();
  }

  void fetchProfiledata() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      QuerySnapshot dataSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email",
              isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
          .get();
      if (mounted) {
        setState(() {
          userData = dataSnapshot.docs[0].data();
          isLoading = false;
          docID = userData['docId'];
          _downloadUrl = userData['profile_image_url'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        _image = File(image!.path);
        isLoading = true;
      });
    }
    final Reference reference = FirebaseStorage.instance
        .ref()
        .child("profile_image")
        .child(FirebaseAuth.instance.currentUser!.email.toString());
    final UploadTask uploadTask = reference.putFile(_image);
    await uploadTask.whenComplete(() => print("File uploaded sucessfully"));

    final String downloadUrl = await reference.getDownloadURL();

    if (mounted) {
      setState(() {
        _downloadUrl = downloadUrl;
      });
    }
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get()
          .then((value) => {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(value.docs[0].data()['docId'].toString())
                    .update({"profile_image_url": _downloadUrl})
              });
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image Uploaded SucessFully")));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            isLoading
                ? Loader()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //App bar
                          Container(
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
                                            builder: (context) =>
                                                const Home()));
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                const Text(
                                  "Profile",
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //         title: Text("Choose image soucre"),
                              //         actions: [
                              //           TextButton(
                              //             onPressed: () async {
                              //               uploadImage(ImageSource.camera);
                              //               Navigator.of(context).pop();
                              //             },
                              //             child: Text("Camera"),
                              //           ),
                              //           TextButton(
                              //             onPressed: () {
                              //               uploadImage(ImageSource.gallery);
                              //               Navigator.of(context).pop();
                              //             },
                              //             child: Text("Gallery"),
                              //           ),
                              //         ],
                              //       );
                              //     });
                              uploadImage(ImageSource.gallery);
                            },
                            child: Center(
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9999),
                                  border: Border.all(
                                    width: 4,
                                    color: Colors.black,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  backgroundImage: _downloadUrl != ''
                                      ? NetworkImage(_downloadUrl)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Update Profile Image",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ProfileRow(
                              placeholder: "Username",
                              data: userData['username'].toString()),
                          ProfileRow(
                              placeholder: "Email", data: userData['email']),
                          ProfileRow(
                              placeholder: "Name", data: userData['name']),
                          ProfileRow(
                              placeholder: "Birthday", data: userData['dob']),
                          ProfileRow(placeholder: "Bio", data: userData['bio']),
                          ProfileRow(
                            placeholder: "Account Created At",
                            data: DateFormat('dd-MM-yyyy')
                                .format(userData['created_At'].toDate())
                                .toString(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

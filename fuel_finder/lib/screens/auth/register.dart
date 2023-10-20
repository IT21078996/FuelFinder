import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../../constants/text.dart';
import '../../services/auth.dart';

class Register extends StatefulWidget {
  final Function toggle;
  const Register({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  String error = "";
  File? _image;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                child: const Text(
                  logo,
                  style: descBStyle,
                ),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: const Text(
                    "Welcome!",
                    style: greet,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: const Text(
                    "Sign Up",
                    style: descBStyle,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name input field
                      TextFormField(
                        decoration: txtInputDeco.copyWith(hintText: "Name"),
                        validator: (value) =>
                            value?.isEmpty == true ? "Enter your name" : null,
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Email input field (unchanged)
                      TextFormField(
                        decoration: txtInputDeco,
                        validator: (value) => value?.isEmpty == true
                            ? "Enter a valid email"
                            : null,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Password input field (unchanged)
                      TextFormField(
                        obscureText: true,
                        decoration: txtInputDeco.copyWith(hintText: "Password"),
                        validator: (value) =>
                            value!.length < 6 ? "Enter a valid password" : null,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      // Profile picture upload
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
                        child: _image == null
                            ? Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: textBody,
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 2, color: secondary),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: secondary,
                                ),
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(_image!),
                              ),
                      ),
                      // Error message (unchanged)
                      Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      ),
                      // Login link (unchanged)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: descStyle,
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: primary, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      // Register button (unchanged)
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  name, email, password);

                          if (result == null) {
                            setState(() {
                              error = "Please enter valid information.";
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: textBody,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 2, color: secondary),
                          ),
                          child: const Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

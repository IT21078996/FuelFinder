import 'package:flutter/material.dart';

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
  // reference for the AuhtService
  final AuthService _auth = AuthService();

  // form key
  final _formKey = GlobalKey<FormState>();
  // define states
  String email = "";
  String password = "";
  String error = "";

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
                        // email
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
                        // password
                        TextFormField(
                          obscureText: true,
                          decoration:
                              txtInputDeco.copyWith(hintText: "Password"),
                          validator: (value) => value!.length < 6
                              ? "Enter a valid password"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        // google
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: descStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        // button
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password);

                            if (result == null) {
                              setState(() {
                                error = "please enter a valid email";
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                color: textBody,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(width: 2, color: secondary)),
                            child: const Center(
                                child: Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

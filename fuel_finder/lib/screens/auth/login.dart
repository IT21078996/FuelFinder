import 'package:fuel_finder/constants/colors.dart';
import 'package:fuel_finder/constants/styles.dart';
import 'package:fuel_finder/constants/text.dart';
import 'package:fuel_finder/services/auth.dart';
import 'package:flutter/material.dart';

import '../AdminH.dart';
import '../home.dart';

class Login extends StatefulWidget {
  final Function toggle;
  const Login({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
        title: const Text("Login"),
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
                    desc,
                    style: greet,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: const Text(
                    descBold,
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
                          decoration:
                              txtInputDeco2.copyWith(labelText: "Email"),
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
                              txtInputDeco2.copyWith(labelText: "Password"),
                          validator: (value) => value!.length < 6
                              ? "Enter a valid password"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                        // google
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account yet?",
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
                                "Register",
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
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                            if (result == null) {
                              setState(() {
                                error = "Invalid email or password";
                              });
                            }else{
                              // Check if the user's email is 'admin@gmail.com'
                              if (email == 'admin@gmail.com' && password == 'admin123') {
                                Navigator.of(context).pushReplacement( // Use pushReplacement to replace the current page.
                                  MaterialPageRoute(
                                    builder: (context) => AdminHomePage(), // Replace AdminHomePage with your actual admin home page.
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushReplacement( // Use pushReplacement to replace the current page.
                                  MaterialPageRoute(
                                    builder: (context) => Home(), // Replace AdminHomePage with your actual admin home page.
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: buttonDeco,
                            child: const Center(
                                child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            dynamic result = await _auth.signInAnonymous();
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: buttonDeco,
                            child: const Center(
                                child: Text(
                              "Login as Guest",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                          ),
                        )
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

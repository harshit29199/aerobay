import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class LoginPage1 extends StatefulWidget {
  const LoginPage1({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage1> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  String _username = '';
  String _password = '';

  AppTheme aa=AppTheme();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30), // Rounded border
                      color: Colors.white,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.1),
                      //     blurRadius: 10,
                      //     spreadRadius: 5,
                      //   ),
                      // ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey, // Assign the form key
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Header section (App Icon, App Name, Exit Button)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.app_registration,
                                      size: 50,
                                    ),
                                    // SizedBox(
                                    //   width: MediaQuery.of(context).size.width * 0.1,
                                    //   child: IconButton(
                                    //     // iconSize: MediaQuery.of(context).size.width * 0.28,
                                    //       icon:  Image.asset('assets/images/neonlogo.png'),
                                    //       onPressed: () {}),
                                    // ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.07,
                                    ),
                                    Text(
                                      aa.title,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.exit_to_app, size: 30),
                                  onPressed: () {
                                    // Add exit functionality here
                                    print("Exit button pressed");
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            // Username / User ID Text
                            Row(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.135
                                ),
                                const Text(
                                  'User ID / Username',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Username TextFormField with validation
                            Container(
                              width: MediaQuery.of(context).size.width * 0.63, // Reduce textfield width
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  hintText: 'Enter your username',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _username = value ?? '';
                                },
                              ),
                            ),
                            const SizedBox(height:10),

                            // Password Text
                            Row(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.135
                                ),
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Password TextFormField with validation
                            Container(
                              width: MediaQuery.of(context).size.width * 0.63, // Reduce textfield width
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  hintText: 'Enter your password',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _password = value ?? '';
                                },
                              ),
                            ),
                            const SizedBox(height: 3),

                            // Remember Me & Forgot Password
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        _rememberMe = newValue ?? false;
                                      });
                                    },
                                  ),
                                  const Text('Remember Me'),
                                  SizedBox(width:  MediaQuery.of(context).size.width * 0.135),
                                  GestureDetector(
                                    onTap: () {
                                      print("Forgot password pressed");
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // const SizedBox(height: 20),

                            // Login Button with form validation
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  side: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  // If form is valid, save the fields
                                  _formKey.currentState?.save();

                                  // Add login functionality here
                                  print("Login button pressed");
                                  print("Username: $_username");
                                  print("Password: $_password");
                                }
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

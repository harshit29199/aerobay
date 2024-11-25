import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage1> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _userEmail = '';
  String _password = '';
  String _selectedGender = '';  // To store selected gender
  String _selectedCategory = '';  // To store selected category

  AppTheme aa = AppTheme();

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
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Header section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.app_registration,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.07,
                                    ),
                                    Text(
                                      aa.title,
                                      style: aa.titleStyle,
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.exit_to_app, size: 30),
                                  onPressed: () {
                                    print("Exit button pressed");
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            // Username Field
                            Row(
                              children: [
                                buildInputLabel('User ID'),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.125),
                                buildInputLabel('Username'),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.135),
                                buildTextField1('Employee ID / Student ID', (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Employee/Student ID';
                                  }
                                  return null;
                                }, (value) => _userEmail = value!),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                buildTextField1('Username', (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                }, (value) => _username = value!),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Password Field
                            buildInputLabel('Password'),
                            buildTextField('Enter your password', (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            }, (value) => _password = value!, obscureText: true),
                            const SizedBox(height: 10),

                            // Gender and Category Labels
                            Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.135),
                                Text('Gender', style: aa.labelStyle),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                                Text('Category', style: aa.labelStyle),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Gender and Category Options
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.135),
                                // Gender options
                                buildSelectableOption('Male', _selectedGender, () {
                                  setState(() {
                                    _selectedGender = 'Male';
                                  });
                                }),
                                const SizedBox(width: 10),
                                buildSelectableOption('Female', _selectedGender, () {
                                  setState(() {
                                    _selectedGender = 'Female';
                                  });
                                }),
                                const SizedBox(width: 40),
                                // Category options
                                buildSelectableOption('Teacher', _selectedCategory, () {
                                  setState(() {
                                    _selectedCategory = 'Teacher';
                                  });
                                }),
                                const SizedBox(width: 10),
                                buildSelectableOption('Student', _selectedCategory, () {
                                  setState(() {
                                    _selectedCategory = 'Student';
                                  });
                                }),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Sign-Up and Login Buttons
                            buildActionButtons(context),
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

  // Reusable method to build text fields
  Widget buildTextField(String hintText, FormFieldValidator<String> validator, FormFieldSetter<String> onSaved, {bool obscureText = false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.63,
      child: TextFormField(
        obscureText: obscureText,
        style: aa.inputStyle,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
  Widget buildTextField1(String hintText, FormFieldValidator<String> validator, FormFieldSetter<String> onSaved, {bool obscureText = false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
        obscureText: obscureText,
        style: aa.inputStyle,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  // Reusable method to build input labels
  Widget buildInputLabel(String text) {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.135),
        Text(text, style: aa.labelStyle),
      ],
    );
  }

  // Reusable method to build selectable options (gender/category)
  Widget buildSelectableOption(String text, String selectedValue, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(4),
          color: selectedValue == text ? Colors.black : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Text(
          text,
          style: TextStyle(
            color: selectedValue == text ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Reusable method to build action buttons
  Widget buildActionButtons(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.135),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              print("Username: $_username");
              print("Password: $_password");
              print("Gender: $_selectedGender");
              print("Category: $_selectedCategory");
            }
          },
          child: Text(
            'Sign Up',
            style: aa.buttonTextStyle,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
          },
          child: Text(
            'Login',
            style: aa.buttonTextStyle,
          ),
        ),
      ],
    );
  }
}

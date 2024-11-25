import 'dart:ui';

import 'package:ssss/utils/helpermethods.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vibration/vibration.dart';
import '../../utils/appcolors.dart';
import '../../utils/images.dart';
import '../../utils/theme.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _otpController = TextEditingController();
  bool isStudentSelected = true; // State for the "Student" button
  bool isTrainerSelected = false; // State for the "Trainer" button
  final maskFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _userEmail = '';
  String _password = '';
  String _selectedGender = ''; //
  String _selectedUserCategory = 'student';
  bool _otpFieldVisible = false;
  String _selectDOB = '';
  String _otp = '';
  String _selectGrade = '';
  String _selectSchool = '';
  bool _isEmailValid = true;
  bool _isUsernameValid = true;
  bool _isPasswordValid = true;
  bool _isSchoolValid = true;
  bool _isDOBValid = true;
  bool _isGradeValid = true;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  AppTheme aa = AppTheme();


  Future<void> _signUp() async {
    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Ensure that _selectedUserCategory has value 'trainer' or 'student'
      if (_selectedUserCategory.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Trainer or Student.')),
        );
        return;
      }

      // Validate the Date of Birth (studentDoB)
      if (_selectDOB.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a valid Date of Birth.')),
        );
        return;
      }

      DateTime? dateOfBirth;
      try {
        // Parse the selected date of birth (assuming it's in 'DD/MM/YYYY' format)
        dateOfBirth = DateFormat('dd/MM/yyyy').parse(_selectDOB);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Date of Birth format.')),
        );
        return;
      }

      // Check if the Date of Birth is in the future
      DateTime currentDate = DateTime.now();
      if (dateOfBirth.isAfter(currentDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Date of Birth cannot be in the future.')),
        );
        return;
      }

      // Prepare the payload
      final Map<String, dynamic> payload = {
        'email': _userEmail,
        'username': _username,
        'password': _password,
        'user_category': _selectedUserCategory, // 'trainer' or 'student'
        'gender': _selectedGender,
        'studentDoB': _selectDOB, // Pass the valid DOB as a string
        'studentGrade': _selectGrade,
        'schoolName': _selectSchool,
      };

      // Print the request payload
      print("Request Payload: ${jsonEncode(payload)}");

      // Show loader before hitting the API
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog from being dismissed
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Send the request to the server
      final response = await http.post(
        Uri.parse('https://cspv.in/aerobay/authorization/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      // Print the response status and body
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Close the loading dialog
      Navigator.of(context).pop();

      // Handle the response
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['message'] == 'OTP sent to your email. Please verify.') {
          // Show the dialog when OTP is sent to the email
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AlertDialog(
                  contentPadding: EdgeInsets.all(10),
                  scrollable: true,
                  backgroundColor:
                  AppColor.instanse.containerGradient.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Verification", style: aa.titleStyle),
                      heightGap(10),
                      Text(
                          "Please enter the Verification Code sent to your email.",
                          style: aa.hintStyle),
                      heightGap(10),
                      TextFormField(
                        controller: _otpController,
                        validator: (text) {
                          if (text!.split(' ').length > 6) {
                            return 'Reached max words';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: AppColor.instanse.greyOnBlack,
                          labelText: 'Enter OTP',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _otp = value;
                        },
                        style: aa.titleStyle,
                      ),
                      heightGap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text("Cancel",
                                  style: TextStyle(
                                      color: AppColor.instanse.greyOnBlack)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _verifyOtp(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    AppColor.instanse.buttonGradient,
                                    AppColor.instanse.colorWhite,
                                  ],
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text("Verify OTP",
                                  style: aa.primaryButtonTextSTyle),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          // For any other response message, show it in a Fluttertoast
          Fluttertoast.showToast(
            msg: responseData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        // If the response code is not 200, show a SnackBar with a failure message
        Fluttertoast.showToast(
          msg: 'Sign-up failed. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }


  // else {
  //   // Prepare the payload for verifying OTP
  //   final Map<String, dynamic> payload = {
  //     'email': _userEmail,
  //     'username': _username,
  //     'password': _password,
  //     'user_category': _selectedUserCategory,
  //     'gender': _selectedGender,
  //     'otp': _otp,
  //     'studentDoB': _selectDOB,
  //     'studentGrade': _selectGrade,
  //     'schoolName': _selectSchool,
  //   };
  //
  //   // Show loader before hitting the API
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );
  //
  //   // Send the request to the server
  //   final response = await http.post(
  //     Uri.parse('https://cspv.in/aerobay/authorization/verify.php'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(payload),
  //   );
  //
  //   // Close the loading dialog
  //   Navigator.of(context).pop();
  //
  //   // Handle the response
  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     if (responseData['message'] == 'Registration successful.') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Registration successful')),
  //       );
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LoginPage()),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(responseData['message'])),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Sign-up failed. Please try again.')),
  //     );
  //   }
  // }
  // }

  String phpurl = "https://cspv.in/aerobay/authorization/verify.php";
  void _verifyOtp(BuildContext context) async {
    print(_username.toString());
    print(_userEmail.toString());
    print(_otpController.text);
    final jsonData = {
      'email': _userEmail,
      'username': _username,
      'password': _password,
      'user_category': _selectedUserCategory,
      'gender': _selectedGender,
      'otp': _otpController.text, // Use text from controller directly
      'studentDoB': _selectDOB,
      'studentGrade': _selectGrade,
      'schoolName': _selectSchool
    };

    final encodedData = jsonEncode(jsonData);
    final headers = {
      'Content-Type': 'application/json',
    };

    var response =
        await http.post(Uri.parse(phpurl), headers: headers, body: encodedData);

    try {
      // final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Registration successful.') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          Fluttertoast.showToast(
            msg: responseData['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('Error uploading PDF and data: $e');
      Fluttertoast.showToast(msg: 'Error uploading PDF and data: $e');
    }
  }

  bool _loginidValid = true;
  bool _loginidvisible = false;


  Future<void> _checkUserExistence(String value) async {
    try {
      // API URL
      final url = Uri.parse("https://cspv.in/aerobay/authorization/id_Check.php");

      // Prepare the request payload
      final payload = jsonEncode({"user": value});

      // Make the POST request
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // Set the header for JSON payload
        },
        body: payload,
      );

      // Decode the response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Update the `exists` variable based on the response
        if (responseData.containsKey('exists')) {
          setState(() {
            _loginidValid = responseData['exists'];
            // Fluttertoast.showToast(msg: _loginidValid.toString());
            _loginidvisible=true;
          });
        }
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConnectivityWidgetWrapper(
        child: SafeArea(
          child: Stack(children: [
            Image.asset(login_screen_bg,
                fit: BoxFit.cover, width: sWidth, height: sHeight),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: sWidth * 0.02, vertical: sHeight * 0.04),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10), // Rounded border
                      color: AppColor.instanse.blurColor
                          .withOpacity(0.2), // Transparency
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // Header section
                          Padding(
                            padding: EdgeInsets.only(
                                left: sWidth * 0.02,
                                top: sHeight * 0.04,
                                right: sWidth * 0.02),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(aerobayLogo,
                                    height: MediaQuery.of(context).size.height *
                                        0.1),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isStudentSelected = true;
                                          isTrainerSelected = false;
                                          _selectedUserCategory =
                                              'student'; // Set the selected category as 'student'
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            colors: [
                                              AppColor.instanse.buttonGradient,
                                              AppColor.instanse.colorWhite,
                                            ],
                                          ),
                                          color: isStudentSelected
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 8),
                                        child: Text(
                                          'Student',
                                          style: TextStyle(
                                            color: isStudentSelected
                                                ? AppColor.instanse.blurColor
                                                : AppColor.instanse.greyOnBlack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    widthGap(sWidth * 0.02),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isStudentSelected = false;
                                          isTrainerSelected = true;
                                          _selectedUserCategory = 'trainer';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            colors: [
                                              AppColor.instanse.buttonGradient,
                                              AppColor.instanse.colorWhite,
                                            ],
                                          ),
                                          color: isTrainerSelected
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 8),
                                        child: Text(
                                          'Trainer',
                                          style: TextStyle(
                                            color: isTrainerSelected
                                                ? AppColor.instanse.blurColor
                                                : AppColor.instanse.greyOnBlack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                    onTap: () {
                                      Vibration.vibrate(duration: 140);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .white, // Set the color to white
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Optional: add rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.3), // Color of the shadow
                                              spreadRadius:
                                                  0, // Spread radius of the shadow
                                              blurRadius:
                                                  5, // Blur radius of the shadow
                                              offset: const Offset(
                                                  1, 1), // Offset of the shadow
                                            ),
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.3), // Inner shadow color (optional)
                                              spreadRadius: -1,
                                              blurRadius: 2,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(backIcon,
                                            height: sHeight * 0.13)))
                              ],
                            ),
                          ),
                          // Username Field
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: sWidth * 0.014,
                              left: sWidth * 0.175,
                              right: sWidth * 0.155,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildInputLabel("Email ID"),
                                        heightGap(sHeight * 0.005),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width * 0.3,
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: _isEmailValid
                                                      ? Colors.grey.withOpacity(0.5)
                                                      : Colors.red),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: TextFormField(
                                            controller: _emailController,
                                            style: aa.inputStyle,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              filled: true,
                                              fillColor: AppColor
                                                  .instanse.blurColor
                                                  .withOpacity(0.5),
                                              hintStyle: GoogleFonts.ubuntu(
                                                  color: _isEmailValid
                                                      ? AppColor
                                                          .instanse.greyOnBlack
                                                      : Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                              hintText: _isEmailValid
                                                  ? 'Enter Email ID'
                                                  : 'Please enter your Email ID',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  _isEmailValid =
                                                      false; // Invalid if empty
                                                });
                                                return null;
                                              }

                  

                                              setState(() {
                                                _isEmailValid =
                                                    true; // Valid if not empty
                                              });
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _userEmail = value ?? '';
                                            },
                                          ),
                                        ),
                  
                                        ///OLD TEXTFIELD FOR EMAIL
                                        // buildTextField1('Enter Email ID',
                                        //     (value) {
                                        //   if (value == null ||
                                        //       value.isEmpty) {
                                        //     return 'Please enter your Email ID';
                                        //   }
                                        //
                                        //   // Regular expression for validating email address
                                        //   final emailRegex = RegExp(
                                        //       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|edu|org|net|gov)$');
                                        //
                                        //   if (!emailRegex.hasMatch(value)) {
                                        //     return 'Please enter a valid email address (gmail or domain specific).';
                                        //   }
                                        //   return null;
                                        // }, (value) => _userEmail = value!),
                  
                                        heightGap(sHeight * 0.02),
                                        SizedBox(
                                          width: sWidth * 0.29,
                                          child: Row(children: [
                                            buildInputLabel('Password'),
                                            Spacer(),
                                            Text(
                                              "*Must contain alphabets & numbers",
                                              style: aa.suggestionText,
                                            ),
                                          ]),
                                        ),
                                        heightGap(sHeight * 0.005),
                  
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: _isPasswordValid
                                                      ? Colors.grey.withOpacity(0.5)
                                                      : Colors.red),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: TextFormField(
                                            controller: _passwordController,
                                            style: aa.inputStyle,
                                            onChanged: (value){
                                              // if (value.isNotEmpty) {
                                              //   _checkUserExistence(_usernameController.text); // Call the API if input length > 0
                                              // }
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: AppColor
                                                  .instanse.blurColor
                                                  .withOpacity(0.5),
                                              hintStyle: GoogleFonts.ubuntu(
                                                  color: _isPasswordValid
                                                      ? AppColor
                                                          .instanse.greyOnBlack
                                                      : Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              hintText: _isPasswordValid
                                                  ? 'Enter your password'
                                                  : 'Please enter your password',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  _isPasswordValid =
                                                      false; // Invalid if empty
                                                });
                                                return null;
                                              }
                                              setState(() {
                                                _isPasswordValid =
                                                    true; // Valid if not empty
                                              });
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _password = value ?? '';
                                            },
                                          ),
                                        ),
                  
                                        /// OLD PASSWORD TEXT FIELD
                                        // buildTextField('Enter your password',
                                        //     (value) {
                                        //   if (value == null ||
                                        //       value.isEmpty) {
                                        //     return 'Please enter your password';
                                        //   }
                                        //   return null;
                                        // }, (value) => _password = value!,
                                        //     obscureText: true),
                  
                                        isTrainerSelected
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  heightGap(sHeight * 0.01),
                                                  Text('Gender',
                                                      style: aa.labelStyle),
                                                  heightGap(sHeight * 0.01),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedGender =
                                                                'Male';
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .centerRight,
                                                                end: Alignment
                                                                    .centerLeft,
                                                                colors: [
                                                                  AppColor
                                                                      .instanse
                                                                      .buttonGradient,
                                                                  AppColor
                                                                      .instanse
                                                                      .colorWhite,
                                                                ]),
                                                            color: _selectedGender ==
                                                                    'Male'
                                                                ? Colors.white
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 5),
                                                          child: Text(
                                                            'Male',
                                                            style: TextStyle(
                                                              color: _selectedGender ==
                                                                      'Male'
                                                                  ? AppColor
                                                                      .instanse
                                                                      .blurColor
                                                                  : AppColor
                                                                      .instanse
                                                                      .greyOnBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      widthGap(sWidth * 0.02),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectedGender =
                                                                'Female';
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .centerRight,
                                                                end: Alignment
                                                                    .centerLeft,
                                                                colors: [
                                                                  AppColor
                                                                      .instanse
                                                                      .buttonGradient,
                                                                  AppColor
                                                                      .instanse
                                                                      .colorWhite,
                                                                ]),
                                                            color: _selectedGender ==
                                                                    'Female'
                                                                ? Colors.white
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      25,
                                                                  vertical: 5),
                                                          child: Text(
                                                            'Female',
                                                            style: TextStyle(
                                                              color: _selectedGender ==
                                                                      'Female'
                                                                  ? AppColor
                                                                      .instanse
                                                                      .blurColor
                                                                  : AppColor
                                                                      .instanse
                                                                      .greyOnBlack,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  heightGap(sHeight * 0.02),
                                                  buildInputLabel(
                                                      'Date of Birth'),
                                                  heightGap(sHeight * 0.005),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: _isDOBValid
                                                                ? Colors.grey.withOpacity(0.5)
                                                                : Colors.red),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    width: sWidth * 0.3,
                                                    child: TextFormField(
                                                      controller:
                                                          _dobController,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _selectDOB = val;
                                                        });
                                                      },
                                                      inputFormatters: [
                                                        maskFormatter
                                                      ], // You should define this maskFormatter
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style: aa
                                                          .inputStyle, // Your existing style
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor: AppColor
                                                            .instanse.blurColor
                                                            .withOpacity(0.5),
                                                        filled: true,
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide.none,
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                        hintText: _isDOBValid
                                                            ? 'DD/MM/YYYY'
                                                            : 'Please enter DOB', // Conditional hint text
                                                        hintStyle: _isDOBValid
                                                            ? aa.hintStyle
                                                            : aa.hintStyle.copyWith(
                                                                color: Colors
                                                                    .red), // Red color for error
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            _isDOBValid =
                                                                false; // Invalid if empty
                                                          });
                                                          return null; // Don't show default error message
                                                        }
                  
                                                        // Check the format using regex
                                                        final dateRegex = RegExp(
                                                            r'^\d{2}/\d{2}/\d{4}$');
                                                        if (!dateRegex
                                                            .hasMatch(value)) {
                                                          setState(() {
                                                            _isDOBValid =
                                                                false; // Invalid if format doesn't match
                                                          });
                                                          return null;
                                                        }
                  
                                                        // Split the input into day, month, year
                                                        final parts =
                                                            value.split('/');
                                                        final day =
                                                            int.parse(parts[0]);
                                                        final month =
                                                            int.parse(parts[1]);
                                                        final year =
                                                            int.parse(parts[2]);
                  
                                                        // Validate the month
                                                        if (month < 1 ||
                                                            month > 12) {
                                                          setState(() {
                                                            _isDOBValid = false;
                                                          });
                                                          return null;
                                                        }
                  
                                                        // Validate the day based on the month and leap years
                                                        final isLeapYear =
                                                            (year % 4 == 0 &&
                                                                    year % 100 !=
                                                                        0) ||
                                                                (year % 400 ==
                                                                    0);
                                                        final daysInMonth = [
                                                          31, // January
                                                          (isLeapYear
                                                              ? 29
                                                              : 28), // February
                                                          31, // March
                                                          30, // April
                                                          31, // May
                                                          30, // June
                                                          31, // July
                                                          31, // August
                                                          30, // September
                                                          31, // October
                                                          30, // November
                                                          31, // December
                                                        ];
                  
                                                        if (day < 1 ||
                                                            day >
                                                                daysInMonth[
                                                                    month -
                                                                        1]) {
                                                          setState(() {
                                                            _isDOBValid =
                                                                false; // Invalid day for the given month
                                                          });
                                                          return null;
                                                        }
                  
                                                        setState(() {
                                                          _isDOBValid =
                                                              true; // Validation passed
                                                        });
                                                        return null; // Validation passed
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: sWidth * 0.29,
                                          child: Row(
                                            children: [
                                              buildInputLabel('Username'),
                                              const Spacer(),
                                              Text(
                                                "*Must Be Unique",
                                                style: aa.suggestionText,
                                              ),
                                            ],
                                          ),
                                        ),
                                        heightGap(sHeight * 0.005),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: _isUsernameValid
                                                      ? Colors.grey.withOpacity(0.5)
                                                      : Colors.red),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: TextFormField(
                                            onChanged: (value){
                                              if (value.isNotEmpty) {
                                                _checkUserExistence(_usernameController.text); // Call the API if input length > 0
                                              }
                                            },
                                            controller: _usernameController,
                                            style: aa.inputStyle,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Visibility(
                                                  visible:_loginidvisible,
                                                  child: Icon(
                                                    _loginidValid
                                                        ? Icons.close
                                                        :  Icons.check,
                                                    color: _loginidValid?Colors.red:Colors.green,
                                                  ),
                                                ),
                                                onPressed: () {
                                                },
                                              ),
                                              filled: true,
                                              fillColor: AppColor
                                                  .instanse.blurColor
                                                  .withOpacity(0.5),
                                              hintStyle: GoogleFonts.ubuntu(
                                                  color: _isUsernameValid
                                                      ? AppColor
                                                          .instanse.greyOnBlack
                                                      : Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              hintText: _isUsernameValid
                                                  ? 'Enter Username'
                                                  : 'Please enter your Username',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  _isUsernameValid =
                                                      false; // Invalid if empty
                                                });
                                                return null;
                                              }
                                              setState(() {
                                                _isUsernameValid =
                                                    true; // Valid if not empty
                                              });
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _username = value ?? '';
                                            },
                                          ),
                                        ),
                                        heightGap(sHeight * 0.02),
                                        Text(
                                          "School Name",
                                          style: aa.labelStyle,
                                        ),
                                        heightGap(sHeight * 0.005),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: _isSchoolValid
                                                      ? Colors.grey.withOpacity(0.5)
                                                      : Colors.red),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: TextFormField(
                                            controller: _schoolController,
                                            style: aa.inputStyle,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: AppColor
                                                  .instanse.blurColor
                                                  .withOpacity(0.5),
                                              hintStyle: GoogleFonts.ubuntu(
                                                  color: _isSchoolValid
                                                      ? AppColor
                                                          .instanse.greyOnBlack
                                                      : Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              hintText: _isSchoolValid
                                                  ? 'Enter School Name'
                                                  : 'Please enter your School Name',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  _isSchoolValid =
                                                      false; // Invalid if empty
                                                });
                                                return null;
                                              }
                                              setState(() {
                                                _isSchoolValid =
                                                    true; // Valid if not empty
                                              });
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _selectSchool = value ?? '';
                                            },
                                          ),
                                        ),
                                        heightGap(sHeight * 0.02),
                                        isStudentSelected
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: sWidth * 0.29,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Grade",
                                                            style:
                                                                aa.labelStyle),
                                                        const Spacer(),
                                                        Text(
                                                          "*Enter in numbers",
                                                          style:
                                                              aa.suggestionText,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  heightGap(sHeight * 0.005),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    padding: EdgeInsets.zero,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: _isGradeValid
                                                                ? Colors.grey.withOpacity(0.5)
                                                                : Colors.red),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: TextFormField(
                                                      controller:
                                                          _gradeController,
                                                      style: aa.inputStyle,
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: AppColor
                                                            .instanse.blurColor
                                                            .withOpacity(0.5),
                                                        hintStyle: GoogleFonts.ubuntu(
                                                            color: _isGradeValid
                                                                ? AppColor
                                                                    .instanse
                                                                    .greyOnBlack
                                                                : Colors.red,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide.none,
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                        hintText: _isGradeValid
                                                            ? 'Enter Your Grade'
                                                            : 'Please enter your Grade',
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            _isGradeValid =
                                                                false; // Invalid if empty
                                                          });
                                                          return null;
                                                        }
                                                        setState(() {
                                                          _isGradeValid =
                                                              true; // Valid if not empty
                                                        });
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        _selectGrade =
                                                            value ?? '';
                                                      },
                                                    ),
                                                  ),
                                                  // buildTextField(
                                                  //     'Enter Your Grade',
                                                  //     (value) {
                                                  //   if (value == null ||
                                                  //       value.isEmpty) {
                                                  //     return 'Please enter your Grade';
                                                  //   }
                                                  //   return null;
                                                  // },
                                                  //     (value) =>
                                                  //         _selectGrade = value!,
                                                  //     obscureText: false),
                                                ],
                                              )
                                            : SizedBox(
                                                height: sHeight * 0.2,
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                                heightGap(sHeight * 0.02),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _signUp();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 21, vertical: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            colors: [
                                              AppColor.instanse.buttonGradient,
                                              AppColor.instanse.colorWhite,
                                            ],
                                          ),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text("Sign up",
                                            style: aa.primaryButtonTextSTyle),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const LoginPage()));
                                      },
                                      child: Row(
                                        children: [
                                          Text("Already have an account? ",
                                              style:
                                                  aa.smallTextStyleUnderLine),
                                          Text("Login",
                                              style: aa.smallTextStyleBold),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // Reusable method to build text fields
  Widget buildTextField(String hintText, FormFieldValidator<String> validator,
      FormFieldSetter<String> onSaved,
      {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(5)),
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
        obscureText: obscureText,
        style: aa.inputStyle,
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.instanse.blurColor.withOpacity(0.5),
            border: const OutlineInputBorder(),
            hintText: hintText,
            hintStyle: aa.hintStyle),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget buildTextField11(String hintText, FormFieldValidator<String> validator,
      FormFieldSetter<String> onSaved,
      {bool obscureText = false}) {
    return SizedBox(
      child: TextFormField(
        obscureText: obscureText,
        style: aa.inputStyle,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
        validator: validator,
        onSaved: onSaved,
        onChanged: (value) {
          _otp = value;
        },
      ),
    );
  }

  Widget buildTextField1(String hintText, FormFieldValidator<String> validator,
      FormFieldSetter<String> onSaved,
      {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
        obscureText: obscureText,
        style: aa.inputStyle,
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.instanse.blurColor.withOpacity(0.5),
            border: const OutlineInputBorder(),
            hintText: hintText,
            hintStyle: aa.hintStyle),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  // Reusable method to build input labels
  Widget buildInputLabel(String text) {
    return Text(text, style: aa.labelStyle);
  }

  // Reusable method to build selectable options (gender/category)
  Widget buildSelectableOption(
      String text, String selectedValue, VoidCallback onTap) {
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

  String buttonText = 'Verify email';
  // Reusable method to build action buttons
  Widget buildActionButtons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _signUp();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  AppColor.instanse.buttonGradient,
                  AppColor.instanse.colorWhite,
                ],
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: Text("Sign up", style: aa.primaryButtonTextSTyle),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const LoginPage()));
          },
          child: Row(
            children: [
              Text("Already have an account? ",
                  style: aa.smallTextStyleUnderLine),
              Text("Login", style: aa.smallTextStyleBold),
            ],
          ),
        ),
      ],
    );
  }
}

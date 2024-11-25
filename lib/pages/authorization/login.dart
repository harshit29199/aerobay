import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ssss/utils/helpermethods.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ssss/pages/authorization/signUp.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import '../../utils/appcolors.dart';
import '../../utils/custom_popup.dart';
import '../../utils/images.dart';
import '../../utils/theme.dart';
import '../home.dart';
import 'forgotPassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  String _username = '';
  String _password = '';
  bool isOtpEnabled = false;
  bool _forgotPasswordClicked = false;
  int secondsRemaining = 10;
  Timer? _timer;
  bool _isObscured = true;
  bool _loginidValid = true;
  bool _loginidvisible = false;
  bool _isUsernameValid = true;
  bool _isPasswordValid = true;

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

  // Controllers for TextFormField (optional but recommended for control)
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Change duration to 1 second
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          isOtpEnabled = false; // Disable the countdown
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  AppTheme aa = AppTheme();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // Loader
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse('https://cspv.in/aerobay/authorization/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user': _username, 'pass': _password}),
      );

      // Close the loading dialog
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == "Login successful.") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                username: data['user']['username'],
                loggedin: _rememberMe,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      // Close the loading dialog if an error occurs
      Navigator.of(context).pop();

      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ConnectivityWidgetWrapper(
        child: Scaffold(
          body: SafeArea(
            child: Stack(
                children: [
              Image.asset(login_screen_bg,
                  fit: BoxFit.cover, width: sWidth, height: sHeight),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sWidth * 0.02,
                    vertical: sHeight * 0.04),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: sHeight * 0.05),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.instanse.blurColor.withOpacity(0.2),
                        // color: Colors.white
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: sWidth * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          aerobayLogo,
                                          height: sHeight *
                                              0.1,
                                        ),
                                        SizedBox(
                                            width: sWidth *
                                                0.062),
                                        Text(
                                          aa.title,
                                          style: aa.titleStyle,
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (_forgotPasswordClicked) {
                                          setState(() {
                                            _forgotPasswordClicked = false;
                                          });
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const CustomOnlyExitPopup();
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.3),
                                              spreadRadius: 0,
                                              blurRadius: 5,
                                              offset: const Offset(1, 1),
                                            ),
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.3),
                                              spreadRadius: -1,
                                              blurRadius: 2,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          backIcon,
                                          height: sHeight * 0.13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        
                              // Conditionally hide or show the user ID/username field
                              _forgotPasswordClicked
                                  ? const ForgotPasswordPage()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: sWidth * 0.145,
                                          right: sWidth * 0.28,
                                          top: sHeight * 0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'User ID / Username',
                                            style: aa
                                                .labelStyle, // Use defined label style
                                          ),
                                          heightGap(sHeight * 0.007),
                                          Container(
                                            padding: EdgeInsets.zero,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: _isUsernameValid
                                                        ? Colors.transparent
                                                        : Colors.red),
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: TextFormField(
                                              controller: _usernameController,
                                              style: aa.inputStyle,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Visibility(
                                                    visible:_loginidvisible,
                                                    child: Icon(
                                                      _loginidValid
                                                          ? Icons.check
                                                          :  Icons.close,
                                                      color: _loginidValid?Colors.green:Colors.red,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                  },
                                                ),
                                                contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 12),
                                                filled: true,
                                                fillColor: AppColor
                                                    .instanse.blurColor
                                                    .withOpacity(0.5),
                                                hintStyle: GoogleFonts.ubuntu(
                                                    color: _isUsernameValid
                                                        ? AppColor.instanse
                                                            .greyOnBlack
                                                        : Colors.red,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                ),
                                                hintText: _isUsernameValid
                                                    ? 'Student ID / Trainer ID'
                                                    : 'Please enter your Student ID/Trainer ID',
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
                                              onChanged: (value){
                                                // setState(() {
                                                //   _loginidvisible=false;
                                                // });
                                                if (value.isNotEmpty) {
                                                  _checkUserExistence(_usernameController.text); // Call the API if input length > 0
                                                }
                                                },
                                              onSaved: (value) {
                                                _username = value ?? '';
                                              },
                                            ),
                                          ),
                                          heightGap(sHeight * 0.02),
                                          // Password Label
                                          Text(
                                            'Password',
                                            style: aa
                                                .labelStyle, // Use defined label style
                                          ),
                        
                                          heightGap(sHeight * 0.007),
                        
                                          // Password Field
                                          Container(
                                            padding: EdgeInsets.zero,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: _isPasswordValid
                                                        ? Colors.transparent
                                                        : Colors.red),
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(10))),
                                            child: TextFormField(
                                              controller: _passwordController,
                                              style: aa
                                                  .inputStyle, // Use defined input style
                                              obscureText: _isObscured,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 12),
                                                fillColor: AppColor
                                                    .instanse.blurColor
                                                    .withOpacity(0.5),
                                                filled: true,
                                                hintStyle: GoogleFonts.ubuntu(
                                                    color: _isUsernameValid
                                                        ? AppColor.instanse
                                                            .greyOnBlack
                                                        : Colors.red,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                ),
                                                hintText: _isPasswordValid
                                                    ? 'Password'
                                                    : 'Please enter your password', // Conditional hint text
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    _isObscured
                                                        ? Icons.visibility
                                                        : Icons
                                                            .visibility_off,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _isObscured =
                                                          !_isObscured;
                                                    });
                                                  },
                                                ),
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
                                              onChanged: (value){
                                                // if (value.isNotEmpty) {
                                                //   _checkUserExistence(_usernameController.text); // Call the API if input length > 0
                                                // }
                                              },
                                              onSaved: (value) {
                                                _password = value ?? '';
                                              },
                                            ),
                                          ),
                                          heightGap(sHeight * 0.02),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Remember me',
                                                    style: aa.smallTextStyle,
                                                  ),
                                                  Checkbox(
                                                    value: _rememberMe,
                                                    onChanged:
                                                        (bool? newValue) {
                                                      setState(() {
                                                        _rememberMe =
                                                            newValue ?? false;
                                                      });
                                                    },
                                                    fillColor:
                                                        WidgetStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    WidgetState>
                                                                states) {
                                                      if (states.contains(
                                                          WidgetState
                                                              .disabled)) {
                                                        return AppColor
                                                            .instanse
                                                            .colorWhite;
                                                      }
                                                      return Colors
                                                          .transparent;
                                                    }),
                                                    visualDensity: VisualDensity
                                                        .compact, // Reduces the default padding around the checkbox
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap, // Shrinks the tap target size
                                                    side: const BorderSide(
                                                      color: Colors
                                                          .white, // Set the border color to white
                                                      width:
                                                          0.5, // Optional: adjust the width of the border
                                                    ),
                                                  )
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  print(
                                                      "Forgot password pressed");
                                                  setState(() {
                                                    _forgotPasswordClicked =
                                                        true;
                                                  });
                                                },
                                                child: Text(
                                                  'Forgot Password?',
                                                  style: aa.smallTextStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Login Button with form validation
                                          heightGap(sHeight * 0.04),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (_formKey.currentState
                                                          ?.validate() ??
                                                      false) {
                                                    _formKey.currentState
                                                        ?.save();
                                                    print(
                                                        "Login button pressed");
                                                    print(
                                                        "Username: $_username");
                                                    print(
                                                        "Password: $_password");
                                                    _login();
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 21,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerRight,
                                                        end: Alignment
                                                            .centerLeft,
                                                        colors: [
                                                          AppColor.instanse
                                                              .buttonGradient,
                                                          AppColor.instanse
                                                              .colorWhite,
                                                        ]),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text("Login",
                                                      style: aa
                                                          .primaryButtonTextSTyle),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              const SignUpPage()));
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        "Don't have an account? ",
                                                        style: aa
                                                            .smallTextStyleUnderLine),
                                                    Text("Sign up",
                                                        style: aa
                                                            .smallTextStyleBold),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          heightGap(sHeight * 0.0245),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

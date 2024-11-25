import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For API call
import 'dart:convert'; // For decoding JSON
import '../../utils/appcolors.dart';
import '../../utils/theme.dart';
import 'login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _otpSent = false; // Flag to track OTP sent state
  bool _otpVerified = false; // Flag to track OTP verification state
  String _user = ''; // For username or email input
  String _otp = ''; // For OTP input
  String _newPassword = ''; // For new password input
  String _confirmPassword = ''; // For confirm password input
  bool isOtpEnabled = false;
  ScrollController controller = ScrollController();
  final String apiUrl = 'https://cspv.in/aerobay/authorization/forgot_pass.php';
  final String apiUrl1 =
      'https://cspv.in/aerobay/authorization/verifyForgot_pass.php';
  int secondsRemaining = 10;
  Timer? _timer;

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

  // Function to call the API and request OTP
  Future<void> requestOtp(String user) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user": user}),
      );

      var data = jsonDecode(response.body);

      if (data['message'] == 'OTP sent to your email.') {
        // OTP was sent successfully
        setState(() {
          _otpSent = true; // Show OTP input field
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully')),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP. Try again.')),
      );
    }
  }

  // Function to handle OTP verification
  Future<void> verifyOtpAndShowPasswordFields(String otp, String user) async {
    // API call to verify OTP
    final response = await http.post(
      Uri.parse(
          'https://cspv.in/aerobay/authorization/verifyOtp.php'), // OTP verification URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user': user,
        'otp': otp,
      }),
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // If OTP is valid, show password fields
      if (responseData['message'] == 'OTP verified successfully.') {
        print(responseData);
        setState(() {
          _otpVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('OTP verified. Please set a new password.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      }
    } else {
      // If OTP is invalid or expired, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${jsonDecode(response.body)['message']}')),
      );
    }
  }

  // Function to handle password reset
  Future<void> resetPassword(
      String user, String otp, String newPassword, BuildContext context) async {
    const String apiUrl =
        "https://cspv.in/aerobay/authorization/verifyForgot_pass.php";

    try {
      // Create the JSON body for the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user": user,
          "otp": otp,
          "new_password": newPassword,
        }),
      );

      // Decode the server response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Check the message returned by the server
        if (responseData['message'] == 'Password updated successfully.') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset successfully!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reset password.')),
        );
      }
    } catch (error) {
      // Handle errors such as network issues
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.04,
      ),
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.height * 0.08,
      ),
      height: MediaQuery.of(context).size.height * 0.57,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.instanse.blurColor.withOpacity(0.8),
            AppColor.instanse.containerGradient.withOpacity(0.7)
          ],
          stops: const [0.0, 1.0],
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          tileMode: TileMode.repeated,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: AppColor.instanse.borderWhite, width: 1),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                children: [
                  Text("Enter Student ID / Trainer ID", style: aa.newText),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              buildTextField(
                'Enter your username or email',
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username or email';
                  }
                  return null;
                },
                onSaved: (value) =>
                    _user = value!, // Save the value on submission
                onChanged: (value) =>
                    _user = value!, // Update _user in real-time
                isEnabled: !_otpSent,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              isOtpEnabled == true
                  ? buildTextField(
                      'Enter the OTP',
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        return null;
                      },
                      onSaved: (value) => _otp = value!,
                      onChanged: (value) => _otp = value!,
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 1,
                            color:
                                AppColor.instanse.colorWhite.withOpacity(0.2)),
                      ),
                      child: TextField(
                        enabled: isOtpEnabled,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter OTP',
                          hintStyle: aa.disableHintStyle,
                        ),
                      ),
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              isOtpEnabled == false
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              requestOtp(_user);
                              isOtpEnabled = true; // Enable countdown
                              secondsRemaining = 60; // Reset countdown value
                              startTimer(); // Start the timer
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 2,
                            ),
                            child: Text(
                              'Send OTP',
                              style: TextStyle(
                                color: AppColor.instanse.blurColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            verifyOtpAndShowPasswordFields(_otp, _user);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String newPassword = '';
                                String confirmPassword = '';
                                String validationMessage = '';

                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: AlertDialog(
                                    scrollable: true,
                                    contentPadding: EdgeInsets.all(10),
                                    titlePadding: EdgeInsets.zero,
                                    backgroundColor: AppColor
                                        .instanse.containerGradient
                                        .withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    /*title: Text("Create New Password",
                                        style: aa.titleStyle),*/
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text("Create New Password",
                                            style: aa.titleStyle),
                                        const SizedBox(height: 20),
                                        Text(
                                          "Please enter your new password and confirm it.",
                                          style: aa.hintStyle,
                                        ),
                                        const SizedBox(height: 20),
                                        buildTextField(
                                          'Enter new password',
                                          (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your new password';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) =>
                                              _newPassword = value!,
                                          onChanged: (value) =>
                                              _newPassword = value!,
                                          obscureText: true,
                                        ),
                                        const SizedBox(
                                            height:
                                                10), // Spacing between fields
                                        buildTextField(
                                          'Confirm new password',
                                          (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please confirm your password';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) =>
                                              _confirmPassword = value!,
                                          onChanged: (value) =>
                                              _confirmPassword = value!,
                                          obscureText: false,
                                        ),
                                        SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              _formKey.currentState?.save();
                                              if (!_otpSent) {
                                                // Request OTP
                                                requestOtp(_user);
                                              } else if (_otpSent &&
                                                  !_otpVerified) {
                                                // Verify OTP
                                                if (_otp.length == 6) {
                                                  verifyOtpAndShowPasswordFields(
                                                      _otp, _user);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Invalid OTP!')),
                                                  );
                                                }
                                              } else if (_otpVerified) {
                                                // Reset password
                                                if (_newPassword ==
                                                    _confirmPassword) {
                                                  resetPassword(_user, _otp,
                                                      _newPassword, context);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Passwords do not match.')),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  AppColor
                                                      .instanse.buttonGradient,
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
                                            child: Text("Done",
                                                style:
                                                    aa.primaryButtonTextSTyle),
                                          ),
                                        ),
                                        /*TextField(
                                          obscureText:
                                              true, // To hide password input
                                          onChanged: (value) {
                                            confirmPassword =
                                                value; // Capture confirm password
                                          },
                                          decoration: InputDecoration(
                                            fillColor:
                                                AppColor.instanse.greyOnBlack,
                                            labelText: 'Confirm New Password',
                                            border: const OutlineInputBorder(),
                                          ),
                                          style: aa.hintStyle,
                                        ),*/
                                        const SizedBox(
                                            height:
                                                10), // Spacing for validation message
                                        if (validationMessage
                                            .isNotEmpty) // Show validation message if exists
                                          Text(
                                            validationMessage,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                      ],
                                    ),
                                    /*actions: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          if (_formKey.currentState?.validate() ??
                                              false) {
                                            _formKey.currentState?.save();
                                            if (!_otpSent) {
                                              // Request OTP
                                              requestOtp(_user);
                                            } else if (_otpSent &&
                                                !_otpVerified) {
                                              // Verify OTP
                                              if (_otp.length == 6) {
                                                verifyOtpAndShowPasswordFields(
                                                    _otp, _user);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content:
                                                          Text('Invalid OTP!')),
                                                );
                                              }
                                            } else if (_otpVerified) {
                                              // Reset password
                                              if (_newPassword ==
                                                  _confirmPassword) {
                                                resetPassword(_user, _otp,
                                                    _newPassword, context);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Passwords do not match.')),
                                                );
                                              }
                                            }
                                          }
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text("Done",
                                              style: aa.primaryButtonTextSTyle),
                                        ),
                                      ),
                                    ],*/
                                  ),
                                );
                              },
                            );
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 2,
                            ),
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: AppColor.instanse.blurColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 10), // Spacing between the button and text
                        Text(
                          isOtpEnabled
                              ? 'Resend OTP in $secondsRemaining seconds'
                              : 'Resend OTP',
                          style: aa.suggestionText,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
    /*return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: ConnectivityWidgetWrapper(
        child: Scaffold(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.01,
                                ),
                                // Username / Email input
                                buildLabel('User ID / Username'),
                                buildTextField(
                                  'Enter your username or email',
                                      (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your username or email';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => _user = value!,
                                  isEnabled: !_otpSent,
                                ),
                                const SizedBox(height: 10),

                                // OTP input (shown after OTP is sent)
                                if (_otpSent) ...[
                                  buildLabel('Enter OTP'),
                                  buildTextField(
                                    'Enter the OTP',
                                        (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the OTP';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _otp = value!,
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                // New Password fields (shown after OTP verification)
                                if (_otpVerified) ...[
                                  buildLabel('New Password'),
                                  buildTextField(
                                    'Enter new password',
                                        (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your new password';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _newPassword = value!,
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 10),
                                  buildLabel('Confirm Password'),
                                  buildTextField(
                                    'Confirm new password',
                                        (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _confirmPassword = value!,
                                    obscureText: false,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                // Action buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                                          if (!_otpSent) {
                                            // Request OTP
                                            requestOtp(_user);
                                          } else if (_otpSent && !_otpVerified) {
                                            // Verify OTP
                                            if(_otp.length==6){
                                            verifyOtpAndShowPasswordFields(_otp,_user);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Invalid OTP!')),
                                              );
                                            }
                                          } else if (_otpVerified) {
                                            // Reset password
                                            if (_newPassword == _confirmPassword) {
                                              resetPassword(_user,_otp,_newPassword,context);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Passwords do not match.')),
                                              );
                                            }
                                          }
                                        }
                                      },
                                      child: Text(
                                        !_otpSent
                                            ? 'Verify Email'
                                            : _otpVerified
                                            ? 'Reset Password'
                                            : 'Verify OTP',
                                        style: aa.buttonTextStyle,
                                      ),
                                    ),
                                  ],
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
        ),
      ),
    );*/
  }

  // Reusable function to build text fields
  Widget buildTextField(
    String hintText,
    FormFieldValidator<String> validator, {
    required FormFieldSetter<String> onSaved,
    required ValueChanged<String?> onChanged, // Added onChanged parameter
    bool isEnabled = true,
    bool obscureText = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColor.instanse.colorWhite),
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: aa.hintStyle,
        ),
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged, // Set the onChanged callback
        obscureText: obscureText,
        enabled: isEnabled,
      ),
    );
  }

  // Reusable function to build labels
  Widget buildLabel(String labelText) {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.135),
        Text(
          labelText,
          style: aa.labelStyle,
        ),
      ],
    );
  }
}

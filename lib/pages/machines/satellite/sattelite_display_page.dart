import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:ssss/pages/machines/satellite/sattelite_display_page.dart';
import 'package:ssss/pages/machines/windTunnel/permissionCheck.dart';
import 'package:ssss/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../../../logic/JoystickProvider2.dart';
import '../../../logic/mqtt_class.dart';
import '../../../main.dart';
import '../../../utils/appcolors.dart';
import '../../../utils/helpermethods.dart';
import '../../../utils/resources/images.dart';
import '../../extra/outlineborder.dart';
import '../../extra/outlineglowborder.dart';
import 'package:http/http.dart' as http;


class SatelliteDisplayPage extends StatefulWidget {
  const SatelliteDisplayPage({required this.deviceid});
  final String deviceid;
  @override
  State<SatelliteDisplayPage> createState() => _CarPageState();
}

class _CarPageState extends State<SatelliteDisplayPage> {
  bool isPressed1 = false;

  bool isPressed7 = false;
  bool isPressed8 = false;
  String currentIcon = wifi_off_icon;
  void toggleWiFiIcon() {
    if (currentIcon == wifi_off_icon) {
      // Start by showing the connecting icon for 1 second
      setState(() {
        currentIcon = wifi_connecting_icon;
      });

      Timer(Duration(seconds: 1), () {
        // After 1 second, switch to the WiFi on icon
        setState(() {
          currentIcon = wifi_on_icon;
        });
      });
    } else if (currentIcon == wifi_on_icon) {
      // Change back to WiFi off icon
      setState(() {
        currentIcon = wifi_off_icon;
      });
    }
  }

  Widget categoryButton(String category, String label) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          fetchFiles(category); // Fetch files based on selected category
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.145,
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? Colors.white : Colors.grey[300],
        ),
        child: Text(
          label,
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w500,
            fontSize: MediaQuery.of(context).size.width * 0.019,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFiles("ppt");
  }

  String selectedCategory = 'ppt'; // Default to 'ppt'
  List<dynamic> fileNames = [];

  // Function to make the API call
  Future<void> fetchFiles(String category) async {
    final response = await http.post(
      Uri.parse('https://cspv.in/aerobay/satellite/get.php'),
      body: json.encode({"device_id": widget.deviceid}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // final files = json.decode(data['d_file'])['files'];
      final files = json.decode(data['d_file']);
      print(files);
      setState(() {
        fileNames = files
            .where((file) => file['category'] == category)
            .map((file) => file['filename'])
            .toList();
      });
    } else {
      // Handle error if API call fails
      print('Failed to load files');
    }
  }

  // {
  // "files": [
  // {
  // "filename": "report.pdf",
  // "category": "ppt"
  // },
  // {
  // "filename": "presentation.pptx",
  // "category": "video"
  // },
  // {
  // "filename": "code.py",
  // "category": "activity"
  // },
  // {
  // "filename": "image.jpg",
  // "category": "worksheet"
  // }
  // ]
  // }

  Future<void> logFileAccess(String fileName) async {
    final response = await http.post(
      Uri.parse('https://cspv.in/aerobay/satellite/add_Log.php'),
      body: json.encode({
        "device_id": widget.deviceid,
        "file_name": fileName,
      }),
    );

    if (response.statusCode == 200) {
      print('File log added successfully');
    } else {
      print('Failed to log file access');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final joystickProvider = Provider.of<JoystickProvider2>(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/windbg.png',
              fit: BoxFit.cover,
            ),
          ),
          // BackdropFilter for the blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              color: Colors.black.withOpacity(0.1), // Optional: Overlay color
            ),
          ),
          // Centered container with rounded rectangle
          Center(
            child: Container(
              // padding: EdgeInsets.all(8.0),
              ///align issue
              padding: EdgeInsets.all(screenHeight * 0.022),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                border:
                    Border.all(color: Colors.white, width: 1), // White border
              ),
              width: screenWidth * 0.94, // Width of the container
              height: screenHeight * 0.9, // Height of the container
              child: Stack(
                children: [
                  // Top center text "RC Car"
                  Positioned(
                    // top: 20,
                    // left: screenWidth * 0.5 - 70, // Center horizontally
                    top: screenWidth * 0.027,
                    left: screenWidth * 0.39,
                    child: Text(
                      "Satellite Display",
                      style: TextStyle(
                        // fontSize: 24,
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///adjust code
                  Positioned(
                      top: 0,
                      bottom: screenHeight * 0.58,
                      right: screenWidth * 0.02,
                      left: screenWidth * 0.02,
                      child: Container(
                        color: Colors.transparent,
                      )),

                  /// Top right two square containers with asset images
                  Positioned(
                    // top: 16,
                    // right: 16,
                    top: screenHeight * 0.04,
                    right: screenHeight * 0.04,
                    child: Row(
                      children: [
                        SizedBox(
                            width:
                                screenHeight * 0.03), // Spacing between images
                        Container(
                          height: screenHeight * 0.14,
                          width: screenHeight * 0.14,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: isPressed1
                                ? Colors.grey[300]
                                : Colors.white, // Changes color on press
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:
                                isPressed1 // Adds shadow to simulate press effect
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(2, 2),
                                        )
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: const Offset(3, 3),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 1,
                                          blurRadius: 15,
                                          offset: const Offset(-1, -1),
                                        ),
                                      ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Vibration.vibrate();
                              },
                              onTapDown: (_) {
                                setState(() => isPressed1 =
                                    true); // Change state to pressed
                              },
                              onTapUp: (_) {
                                setState(() => isPressed1 =
                                    false); // Change state back on release
                              },
                              onTapCancel: () {
                                setState(() => isPressed1 =
                                    false); // Ensure button resets if tap is canceled
                              },
                              splashColor: Colors.redAccent
                                  .withOpacity(0.3), // Customize splash color
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Image.asset(back_icon),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  /// Top left circular container with asset image
                  Positioned(
                    top: screenHeight * 0.04,
                    left: screenHeight * 0.04,
                    child: Container(
                        height: screenHeight * 0.14,
                        width: screenHeight * 0.14,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: isPressed7
                                ? Colors.grey[300]
                                : Colors.white, // Changes color on press
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: // Adds shadow to simulate press effect
                                [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(3, 3),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: const Offset(-1, -1),
                              ),
                            ]),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Vibration.vibrate(duration: 140);
                              toggleWiFiIcon();
                            },
                            onTapDown: (_) {
                              setState(() =>
                                  isPressed7 = true); // Change state to pressed
                            },
                            onTapUp: (_) {
                              setState(() => isPressed7 =
                                  false); // Change state back on release
                            },
                            onTapCancel: () {
                              setState(() => isPressed7 =
                                  false); // Ensure button resets if tap is canceled
                            },
                            // splashColor: Colors.redAccent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(currentIcon),
                          ),
                        )),
                  ),

                  ///old
                  // Positioned(
                  //   left: screenWidth * 0.02,
                  //   bottom: screenHeight * 0.02,
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: screenHeight * 0.05,
                  //         horizontal: screenWidth * 0.02),
                  //     decoration: BoxDecoration(
                  //         color: AppColor.instanse.borderWhite.withOpacity(0.5),
                  //         borderRadius:
                  //             const BorderRadius.all(Radius.circular(10))),
                  //     child: Column(
                  //       children: [
                  //         Container(
                  //           width: screenWidth * 0.145,
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: screenHeight * 0.01),
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(6),
                  //               color: Colors.white),
                  //           child: Text(
                  //             "PPT",
                  //             style: GoogleFonts.ubuntu(
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: screenWidth * 0.019,
                  //             ),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ),
                  //         heightGap(screenHeight * 0.04),
                  //         Container(
                  //           width: screenWidth * 0.145,
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: screenHeight * 0.01),
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(6),
                  //               color: Colors.white),
                  //           child: Text(
                  //             "Video",
                  //             style: GoogleFonts.ubuntu(
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: screenWidth * 0.019,
                  //             ),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ),
                  //         heightGap(screenHeight * 0.04),
                  //         Container(
                  //           width: screenWidth * 0.145,
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: screenHeight * 0.01),
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(6),
                  //               color: Colors.white),
                  //           child: Text(
                  //             "Activity",
                  //             style: GoogleFonts.ubuntu(
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: screenWidth * 0.019,
                  //             ),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ),
                  //         heightGap(screenHeight * 0.04),
                  //         Container(
                  //           width: screenWidth * 0.145,
                  //           padding: EdgeInsets.symmetric(
                  //               vertical: screenHeight * 0.01),
                  //           decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(6),
                  //               color: Colors.white),
                  //           child: Text(
                  //             "Work Sheet",
                  //             style: GoogleFonts.ubuntu(
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: screenWidth * 0.019,
                  //             ),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  //
                  // Positioned(
                  //   right: screenWidth * 0.02,
                  //   bottom: screenHeight * 0.02,
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(vertical: screenHeight*0.037,horizontal: screenWidth*0.02),
                  //   height: screenHeight*0.533,
                  //     width: screenWidth*0.665,
                  //     decoration: BoxDecoration(
                  //         color: AppColor.instanse.borderWhite.withOpacity(0.5),
                  //         borderRadius:
                  //             const BorderRadius.all(Radius.circular(10))),
                  //     child: GridView.builder(
                  //         gridDelegate:
                  //         const SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 5,
                  //           childAspectRatio: 1.1,
                  //           crossAxisSpacing: 0
                  //         ),
                  //         itemCount:10,
                  //         itemBuilder: (context, index) {
                  //         return Column(
                  //           children: [
                  //             heightGap(screenHeight * 0.005),
                  //             Container(
                  //               padding: EdgeInsets.symmetric(
                  //                   vertical: screenHeight * 0.055,
                  //                   horizontal: screenWidth * 0.035),
                  //               decoration: const BoxDecoration(
                  //                   color: Colors.white),
                  //               child:
                  //                   Image.asset("assets/images/system.png"),
                  //             ),
                  //             heightGap(screenHeight * 0.005),
                  //             Text(
                  //               "Video name",
                  //               style: GoogleFonts.ubuntu(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: screenWidth * 0.014,
                  //               ),
                  //             )
                  //           ],
                  //         );
                  //       }
                  //     ),
                  //   ),
                  // )
                  ///try
                  Positioned(
                    left: screenWidth * 0.02,
                    bottom: screenHeight * 0.02,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.05, horizontal: screenWidth * 0.02),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          categoryButton('ppt', 'PPT'),
                          SizedBox(height: screenHeight * 0.04),
                          categoryButton('video', 'Video'),
                          SizedBox(height: screenHeight * 0.04),
                          categoryButton('activity', 'Activity'),
                          SizedBox(height: screenHeight * 0.04),
                          categoryButton('worksheet', 'Work Sheet'),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.02,
                    bottom: screenHeight * 0.02,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.037, horizontal: screenWidth * 0.02),
                      height: screenHeight * 0.533,
                      width: screenWidth * 0.665,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 0,
                        ),
                        itemCount: fileNames.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(height: screenHeight * 0.005),
                              InkWell(
                                onTap: (){
                                  String ss="aerobay/weather/${widget.deviceid}";
                                  MQTTService.instance.publish(ss, fileNames[index].toString());
                                  logFileAccess(fileNames[index]);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      // vertical: screenHeight * 0.055,
                                      vertical: screenHeight * 0.05,
                                      horizontal: screenWidth * 0.035),
                                  decoration: const BoxDecoration(
                                      color: Colors.white),
                                  child: Image.asset("assets/images/system.png"),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Expanded(
                                child: Text(
                                  fileNames[index],
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth * 0.012,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

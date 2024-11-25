// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
// import 'package:vibration/vibration.dart';
//
// import '../../../../utils/images.dart';
// import '../../../../utils/resources/images.dart';
//
// class UpperBar extends StatefulWidget {
//   const UpperBar( {super.key,required this.index});
//   final String index;
//   @override
//   State<UpperBar> createState() => _UpperBarState();
// }
//
// class _UpperBarState extends State<UpperBar> {
//
//   bool isPressed = false;
//   bool isPressed1 = false;
//   String currentIcon = wifi_off_icon; // Initial icon (wifi_off)
//
//   List<String> schoolNames = [];
//   String? selectedSchool;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchSchoolNames();
//   }
//
//   Future<void> fetchSchoolNames() async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://cspv.in/aerobay/schoolData/get.php'),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"id": ""}),
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         setState(() {
//           schoolNames = data.map((school) => school['schoolname'] as String).toList();
//         });
//       } else {
//         print('Failed to load school names');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   void toggleWiFiIcon() {
//     if (currentIcon == wifi_off_icon) {
//       // Start by showing the connecting icon for 1 second
//       setState(() {
//         currentIcon = wifi_connecting_icon;
//       });
//
//       Timer(Duration(seconds: 1), () {
//         // After 1 second, switch to the WiFi on icon
//         setState(() {
//           currentIcon = wifi_on_icon;
//         });
//       });
//     } else if (currentIcon == wifi_on_icon) {
//       // Change back to WiFi off icon
//       setState(() {
//         currentIcon = wifi_off_icon;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double w = MediaQuery.of(context).size.width;
//     final double h = MediaQuery.of(context).size.height;
//     // Get current date and time
//     final DateTime now = DateTime.now();
//     // Format time as 'HH:mm'
//     final String time = DateFormat('HH:mm').format(now);
//     // Format date as 'EEEE, MMMM dd'
//     final String date = DateFormat('EEEE, MMMM dd').format(now).toUpperCase();
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//             height: h * 0.11,
//             width: w * 0.06,
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white, width: 1),
//                 color: isPressed ? Colors.grey[300] : Colors.white, // Changes color on press
//                 borderRadius: BorderRadius.circular(5),
//                 boxShadow:  // Adds shadow to simulate press effect
//                 [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.5),
//                     spreadRadius: 1,
//                     blurRadius: 8,
//                     offset: const Offset(3, 3),
//                   ),
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     spreadRadius: 1,
//                     blurRadius: 15,
//                     offset: const Offset(-1, -1),
//                   ),
//                 ]
//             ),
//             child:
//             Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 onTap: () {
//                   Vibration.vibrate(duration: 140);
//                   toggleWiFiIcon();
//                 },
//                 onTapDown: (_) {
//                   setState(() => isPressed = true); // Change state to pressed
//                 },
//                 onTapUp: (_) {
//                   setState(() => isPressed = false); // Change state back on release
//                 },
//                 onTapCancel: () {
//                   setState(() => isPressed = false); // Ensure button resets if tap is canceled
//                 },
//                 // splashColor: Colors.redAccent.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.asset(currentIcon),
//               ),
//             )
//         ),
//         // Container(
//         //   padding: const EdgeInsets.symmetric(
//         //       horizontal: 8, vertical: 4),
//         //   decoration: const BoxDecoration(
//         //     gradient: LinearGradient(
//         //       begin: Alignment.centerLeft,
//         //       end: Alignment.centerRight,
//         //       stops: [0.0, 0.5, 0.8],
//         //       colors: [
//         //         Color(0xFFa2cee1),
//         //         Color(0xFFa6d0e3),
//         //         Color(0xFFb7d9ec),
//         //       ],
//         //     ),
//         //     borderRadius: BorderRadius.all(Radius.circular(50)),
//         //   ),
//         //   child: const Row(
//         //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//         //     children: [
//         //       Icon(Icons.location_on_outlined, color: Colors.black),
//         //       Text(
//         //         "JAI SHREE PARIWAL GLOBAL SCHOOL",
//         //         style: TextStyle(color: Colors.black, fontSize: 16),
//         //       )
//         //     ],
//         //   ),
//         // ),
//         Container(
//           height: h * 0.1,
//           width: w * 0.36,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               stops: [0.0, 0.5, 0.8],
//               colors: [
//                 Color(0xFFa2cee1),
//                 Color(0xFFa6d0e3),
//                 Color(0xFFb7d9ec),
//               ],
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(50)),
//           ),
//           padding: EdgeInsets.all(8),
//           child: DropdownButtonHideUnderline(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DropdownButton<String>(
//                 value: selectedSchool,
//                 hint: Row(
//                   children: [
//                     Icon(Icons.location_on_outlined, color: Colors.black),
//                     SizedBox(
//                       width: w * 0.01,
//                     ),
//                     Text("Select School",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
//                   ],
//                 ),
//                 items: schoolNames.map((String school) {
//                   return DropdownMenuItem<String>(
//                     value: school,
//                     child: SizedBox(
//                       width: w * 0.3,
//                       child: Row(
//                         children: [
//                           Icon(Icons.location_on_outlined, color: Colors.black),
//                           SizedBox(
//                             width: w * 0.01,
//                           ),
//                           Expanded(
//                             child: Text(
//                               school,
//                               overflow: TextOverflow.ellipsis, // Adds ellipsis to long text
//                               softWrap: false,
//                               maxLines: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedSchool = newValue;
//                   });
//                 },
//                 icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
//                 dropdownColor: Color(0xFFa2cee1),
//                 style: TextStyle(color: Colors.black, fontSize: 16),
//               ),
//             ),
//           ),
//         ),
//         Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               stops: [0.0, 0.5, 0.8],
//               colors: [
//                 Color(0xFFa2cee1),
//                 Color(0xFFa6d0e3),
//                 Color(0xFFb7d9ec),
//               ],
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(50)),
//           ),
//           padding: const EdgeInsets.all(12),
//           child: Text("$time  $date",
//               style:
//               const TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w400)),
//         ),
//         Container(
//             height: h * 0.11,
//             width: w * 0.06,
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white, width: 1),
//                 color: isPressed1 ? Colors.grey[300] : Colors.white, // Changes color on press
//                 borderRadius: BorderRadius.circular(5),
//                 boxShadow:  // Adds shadow to simulate press effect
//                 [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.5),
//                     spreadRadius: 1,
//                     blurRadius: 8,
//                     offset: const Offset(3, 3),
//                   ),
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     spreadRadius: 1,
//                     blurRadius: 15,
//                     offset: const Offset(-1, -1),
//                   ),
//                 ]
//             ),
//             child:
//             Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                   Vibration.vibrate(duration: 140);
//                 },
//                 onTapDown: (_) {
//                   setState(() => isPressed1 = true); // Change state to pressed
//                 },
//                 onTapUp: (_) {
//                   setState(() => isPressed1 = false); // Change state back on release
//                 },
//                 onTapCancel: () {
//                   setState(() => isPressed1 = false); // Ensure button resets if tap is canceled
//                 },
//                 splashColor: Colors.redAccent.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(10),
//                 ///
//                 child: widget.index=="main"?Image.asset(home_icon):Image.asset(back_icon),
//               ),
//             )
//         ),
//       ],
//     );
//   }
// }

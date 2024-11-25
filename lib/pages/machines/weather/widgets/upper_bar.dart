import 'dart:async';
import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import '../../../../logic/logic.dart';
import '../../../../logic/mqtt_class.dart';
import '../../../../utils/images.dart';
import '../../../../utils/resources/images.dart';
import '../AQI Screen/aqi_screen.dart';
import '../Weather Screen/weather_screen.dart';
import '../weather_manscreen.dart';

class UpperBar extends StatefulWidget {
  const UpperBar( {super.key,required this.index});
  final String index;
  @override
  State<UpperBar> createState() => _UpperBarState();
}

class _UpperBarState extends State<UpperBar> {

  bool isPressed = false;
  bool isPressed1 = false;
  String currentIcon = wifi_off_icon; // Initial icon (wifi_off)
  Map<String, String> schoolToDeviceId = {};  // Store the school name and its associated device ID

  List<String> schoolNames = [];
  String? selectedSchool;
  String deviceid = '';

  @override
  void initState() {
    super.initState();
    fetchSchoolNames();
    // fetchWeatherData1();
  }

  Future<void> fetchSchoolNames() async {
    try {
      final response = await http.post(
        Uri.parse('https://cspv.in/aerobay/schoolData/get.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": ""}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          schoolNames = data.map((school) => school['schoolname'] as String).toList();
          selectedSchool=schoolNames[0];
          context.read<LogicProvider>().setData(selectedSchool!);

          schoolToDeviceId = {
            for (var school in data)
              school['schoolname']: school['device_id'] as String
          };
          deviceid = schoolToDeviceId[selectedSchool] ?? '';
          MQTTService.instance.subscribe("aerobay/weather/$deviceid");
        });
      } else {
        print('Failed to load school names');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> fetchWeatherData1(String selectedDate, String formattedDate1) async {
  Future<void> fetchWeatherData1() async {
    // print(selectedDate);
    // print(formattedDate1);
    DateTime yesterday = DateTime.now();
    DateTime yesterday1 = DateTime.now().subtract(Duration(days: 7));
    String formattedDate = DateFormat('yyyy-MM-dd').format(yesterday);
    String formattedDate1 = DateFormat('yyyy-MM-dd').format(yesterday1);
    print("helloooooooooooooooooo");
    print(formattedDate);
    print(formattedDate1);

    // final requestData = {
    //   "schoolname": selectedSchool,
    //   "startdate": formattedDate1,
    //   "enddate": formattedDate,
    // };
    //
    // try {
    //   final response = await http.post(
    //     Uri.parse("https://cspv.in/aerobay/weatherMan/get.php"),
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode(requestData),
    //   );
    //
    //   if (response.statusCode == 200) {
    //     final responseData = jsonDecode(response.body);
    //
    //     if (responseData['message'] == 'Data retrieved successfully' && responseData['data'] != null) {
    //       final data = responseData['data'][0];
    //       // final data1 = responseData['data'][1];
    //       // final data2= responseData['data'][2];
    //       // final data3 = responseData['data'][3];
    //       // final data4 = responseData['data'][4];
    //       // final data5 = responseData['data'][5];
    //       print("api data");
    //       print(data);
    //       // print(data1);
    //       // print(data2);
    //       // print(data3);
    //       // print(data4);
    //       // print(data5);
    //       // context.read<LogicProvider>().updateWeatherData1(data);
    //       // print(data['weather']['temp']);
    //     } else {
    //       print("Error in response: ${responseData['message']}");
    //       Fluttertoast.showToast(msg: "${responseData['message']}");
    //     }
    //   } else {
    //     print("Failed to fetch data: ${response.statusCode}");
    //   }
    // } catch (e) {
    //   print("Error: $e");
    // }
  }

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

  late StreamSubscription<List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>>> _mqttSubscription;
  String _receivedMessage = "";
  List<DateTime?> _dates = [];
  String _formattedDate = "";

  ///old
  // void _showDatePicker() async {
  //   List<DateTime?>? selectedDates = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: CalendarDatePicker2(
  //             config: CalendarDatePicker2Config(),
  //             value: _dates,
  //             onValueChanged: (dates) {
  //               // print(dates);
  //               // Navigator.pop(context, dates); // Close the dialog and return dates
  //               if (dates.isNotEmpty && dates[0] != null) {
  //                 Navigator.pop(context, dates);
  //               } else {
  //                 Navigator.pop(context, null);
  //               }
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //
  //   // if (selectedDates != null) {
  //   //   setState(() {
  //   //     _dates = selectedDates;
  //   //   });
  //   // }
  //   if (selectedDates != null && selectedDates.isNotEmpty && selectedDates[0] != null) {
  //     setState(() {
  //       DateTime selectedDate = selectedDates[0]!;
  //       _formattedDate = "00:00 ${DateFormat('EEEE, MMMM d').format(selectedDate).toUpperCase()}";
  //       print(_formattedDate);
  //     });
  //
  //   }
  // }

  ///new
  void _showDatePicker() async {
    List<DateTime?>? selectedDates = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(),
              value: _dates,
              onValueChanged: (dates) {
                // print(dates);
                // Navigator.pop(context, dates); // Close the dialog and return dates
                if (dates.isNotEmpty && dates[0] != null && selectedSchool!="") {
                  Navigator.pop(context, dates);
                } else {
                  Navigator.pop(context, null);
                }
              },
            ),
          ),
        );
      },
    );

    // if (selectedDates != null) {
    //   setState(() {
    //     _dates = selectedDates;
    //   });
    // }
    if (selectedDates != null && selectedDates.isNotEmpty && selectedDates[0] != null) {
      setState(() {
        DateTime selectedDate = selectedDates[0]!;
        _formattedDate = "00:00 ${DateFormat('EEEE, MMMM d').format(selectedDate).toUpperCase()}";
        print(_formattedDate);
      });
      DateTime selectedDate = selectedDates[0]!;
      await fetchWeatherData( selectedDate);
    }
  }

  Future<void> fetchWeatherData(DateTime selectedDate) async {
    final requestData = {
      "schoolname": selectedSchool,
      "startdate": DateFormat('yyyy-MM-dd').format(selectedDate),
      "enddate": DateFormat('yyyy-MM-dd').format(selectedDate),
    };

    try {
      final response = await http.post(
        Uri.parse("https://cspv.in/aerobay/weatherMan/get.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['message'] == 'Data retrieved successfully' && responseData['data'] != null) {
          final data = responseData['data'][0];
          // print(data);
          context.read<LogicProvider>().updateWeatherData1(data);
          // print(data['weather']['temp']);
        } else {
          print("Error in response: ${responseData['message']}");
          Fluttertoast.showToast(msg: "${responseData['message']}");
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final logicProvider = Provider.of<LogicProvider>(context);
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    // Get current date and time
    final DateTime now = DateTime.now();
    // Format time as 'HH:mm'
    final String time = DateFormat('HH:mm').format(now);
    // Format date as 'EEEE, MMMM dd'
    final String date = DateFormat('EEEE, MMMM dd').format(now).toUpperCase();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: h * 0.11,
          width: w * 0.06,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            color: isPressed ? Colors.grey[300] : Colors.white, // Changes color on press
            borderRadius: BorderRadius.circular(5),
            boxShadow:  // Adds shadow to simulate press effect
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
            ]
          ),
          child:
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Vibration.vibrate(duration: 140);
                // MQTTService.instance.subscribe("topic");
                // MQTTService.instance.publish("topic", "agfsda");
                // _mqttSubscription = MQTTService.instance.messages!.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> messages) {
                //   final mqtt.MqttPublishMessage recMess = messages[0].payload as mqtt.MqttPublishMessage;
                //   final String message = mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
                //   setState(() {
                //     _receivedMessage = message;  // Update state to display the received message
                //   });
                //   print('Received message: $message');
                // });
                toggleWiFiIcon();
              },
              onTapDown: (_) {
                setState(() => isPressed = true); // Change state to pressed
              },
              onTapUp: (_) {
                setState(() => isPressed = false); // Change state back on release
              },
              onTapCancel: () {
                setState(() => isPressed = false); // Ensure button resets if tap is canceled
              },
              // splashColor: Colors.redAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(currentIcon),
            ),
          )
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(
        //       horizontal: 8, vertical: 4),
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.centerLeft,
        //       end: Alignment.centerRight,
        //       stops: [0.0, 0.5, 0.8],
        //       colors: [
        //         Color(0xFFa2cee1),
        //         Color(0xFFa6d0e3),
        //         Color(0xFFb7d9ec),
        //       ],
        //     ),
        //     borderRadius: BorderRadius.all(Radius.circular(50)),
        //   ),
        //   child: const Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       Icon(Icons.location_on_outlined, color: Colors.black),
        //       Text(
        //         "JAI SHREE PARIWAL GLOBAL SCHOOL",
        //         style: TextStyle(color: Colors.black, fontSize: 16),
        //       )
        //     ],
        //   ),
        // ),
        Container(
          height: h * 0.1,
          width: w * 0.36,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.5, 0.8],
                colors: [
                  Color(0xFFa2cee1),
                  Color(0xFFa6d0e3),
                  Color(0xFFb7d9ec),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          padding: EdgeInsets.all(8),
          child: DropdownButtonHideUnderline(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DropdownButton<String>(
                value: (widget.index=="sub" || widget.index=="sub1") && logicProvider.schoolName.isNotEmpty?logicProvider.schoolName:selectedSchool,
                // value: logicProvider.schoolName,
                hint: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.black),
                    SizedBox(
                      width: w * 0.01,
                    ),
                    Text("Select School",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                  ],
                ),
                items: schoolNames.map((String school) {
                  return DropdownMenuItem<String>(
                    value: school,
                    child: SizedBox(
                      width: w * 0.3,
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.black),
                          SizedBox(
                            width: w * 0.01,
                          ),
                          Expanded(
                            child: Text(
                              school,
                              overflow: TextOverflow.ellipsis, // Adds ellipsis to long text
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  logicProvider.setData(newValue!);
                  setState(() {
                    selectedSchool = newValue;
                    deviceid = schoolToDeviceId[selectedSchool] ?? ''; // Get associated device id
                    print(deviceid);
                  });
                  MQTTService.instance.subscribe("aerobay/weather/$deviceid");
                  // MQTTService.instance.publish("aerobay/weather/$deviceid", "sample json data");
                  // _mqttSubscription = MQTTService.instance.messages!.listen((List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> messages) {
                  //   final mqtt.MqttPublishMessage recMess = messages[0].payload as mqtt.MqttPublishMessage;
                  //   final String message = mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
                  //   setState(() {
                  //     _receivedMessage = message;  // Update state to display the received message
                  //   });
                  //   print('Received message: $message');
                  // });
                  ///try
                  // MQTTService.instance.messageStream.listen((message) {
                  //   // Update weather data when a new message is received
                  //   final weatherData = message['weather'];
                  //   if (weatherData != null) {
                  //     logicProvider.updateWeatherData(weatherData);
                  //   }
                  //   print('Temperature: ${logicProvider.weatherData!['temp']}°C');
                  //   print('Humidity: ${logicProvider.weatherData!['humidity']}%');
                  //   print('Condition: ${logicProvider.weatherData!['info']}');
                  // });
                  ///
                  if(widget.index=="sub"){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  WeatherScreen(school:newValue)));
                  }
                  if(widget.index=="sub1"){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  AqiScreen(school:newValue)));
                  }
                },
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                dropdownColor: Color(0xFFa2cee1),
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ),

        InkWell(
          // onTap: (){
          //   CalendarDatePicker2(
          //     config: CalendarDatePicker2Config(),
          //     value: _dates,
          //     onValueChanged: (dates) => _dates = dates,
          //   );
          // },
          onTap: _showDatePicker,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.5, 0.8],
                colors: [
                  Color(0xFFa2cee1),
                  Color(0xFFa6d0e3),
                  Color(0xFFb7d9ec),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            padding: const EdgeInsets.all(10),
            child: _formattedDate.isEmpty?Text("$time  $date",
                style:
                const TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w400)):Text("$_formattedDate",
                style:
                const TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w400)),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: 12),
          child: Container(
              height: h * 0.11,
              width: w * 0.06,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  color: isPressed1 ? Colors.grey[300] : Colors.white, // Changes color on press
                  borderRadius: BorderRadius.circular(5),
                  boxShadow:  // Adds shadow to simulate press effect
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
                  ]
              ),
              child:
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Vibration.vibrate(duration: 140);
                    // _connect();
                    Navigator.pop(context);
                  },
                  onTapDown: (_) {
                    setState(() => isPressed1 = true); // Change state to pressed
                  },
                  onTapUp: (_) {
                    setState(() => isPressed1 = false); // Change state back on release
                  },
                  onTapCancel: () {
                    setState(() => isPressed1 = false); // Ensure button resets if tap is canceled
                  },
                  splashColor: Colors.redAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  ///
                  child: widget.index=="main"?Image.asset(home_icon):Image.asset(back_icon),
                ),
              )
          ),
        ),
      ],
    );
  }
}

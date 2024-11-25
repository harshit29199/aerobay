// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:write_by_voice/model/model.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:write_by_voice/screens/provider.dart';
// // import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_recognition_error.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:string_stats/string_stats.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:text2pdf/text2pdf.dart';
// import 'package:read_pdf_text/read_pdf_text.dart';
// import 'dart:async';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/services.dart';
// import 'package:write_by_voice/service/database.dart';
//
// // import 'package:intl/intl.dart' as intl;
// import 'dart:math';
//
// enum TtsState { playing, stopped }
//
// class SpeechToTextPage extends StatefulWidget {
//   // final Note? note;
//   // final Function(Note) onNoteSaved;
//
//   const SpeechToTextPage({
//     Key? key,
//     // required this.note,
//     // required this.onNoteSaved,
//   }) : super(key: key);
//
//   @override
//   SpeechToTextPageState createState() => SpeechToTextPageState();
// }
//
// class SpeechToTextPageState extends State<SpeechToTextPage> {
//   final SpeechToText _speechToText = SpeechToText();
//   bool _speechEnabled = false;
//   bool _speechAvailable = false;
//   String _lastWords = '';
//   String resultWords = '';
//   String _currentWords = '';
//   final List<String> _removedWords = [];
//   final String _selectedLocaleId = 'en_En';
//
//   printLocales() async {
//     var locales = await _speechToText.locales();
//     for (var local in locales) {
//       debugPrint(local.name);
//       debugPrint(local.localeId);
//       debugPrint(_currentWords);
//     }
//   }
//
//   DBHelper? _dbHelper;
//   late Future<List<NotesModel>> notesList;
//
//   loadData() async {
//     notesList = _dbHelper!.getCartListWithUserId();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // setState(() {});
//
//     _initSpeech();
//     initTts();
//     _dbHelper = DBHelper();
//     loadData();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   void takePermission() async {
//     PermissionStatus microphoneStatus = await Permission.microphone.status;
//     // LocationPermission permission = await Geolocator.checkPermission();
//     if (microphoneStatus.isGranted) {
//       Fluttertoast.showToast(msg: "DONETRUE");
//     } else {
//       // Microphone permission is not granted, request it
//       PermissionStatus newMicrophoneStatus =
//       await Permission.microphone.request();
//
//       if (newMicrophoneStatus.isGranted) {
//         // Microphone permission granted after request
//         print('Microphone permission granted');
//       } else {
//         // Microphone permission denied
//         print('Microphone permission denied');
//       }
//     }
//   }
//
//   void errorListener(SpeechRecognitionError error) {
//     debugPrint(error.errorMsg.toString());
//     Fluttertoast.showToast(msg: "Unable to detect");
//     Fluttertoast.showToast(msg: "Please restart mic");
//   }
//
//   // NoteControllerR noteController = Get.find<NoteControllerR>();
//   DateTime dateTimenow = DateTime.now();
//
//   void statusListener(String status) async {
//     debugPrint("status $status");
//     if (status == "done" && _speechEnabled) {
//       setState(() {
//         if (_currentWords != " " && _currentWords != "") {
//           _lastWords += " $_currentWords";
//           resultWords += " $_currentWords";
//           _currentWords = "";
//           _speechEnabled = false;
//         }
//       });
//       // notes[currentPageIndex] = _lastWords;
//       await _startListening();
//       // Get.back();
//     }
//   }
//
//   double volume = 0.9;
//   double rate = 0.5;
//   double pitch = 0.6;
//
//   /// This has to happen only once per app
//   void _initSpeech() async {
//     _speechAvailable = await _speechToText.initialize(
//         onError: errorListener, onStatus: statusListener);
//     setState(() {});
//   }
//
//   Future _speak(String message) async {
//     if (Platform.isIOS) {
//       volume = 0.7;
//     } else {
//       volume = 1;
//     }
//     await flutterTts?.setVolume(volume);
//     await flutterTts?.setSpeechRate(rate);
//     await flutterTts?.setPitch(pitch);
//     if (message.isNotEmpty) {
//       //!= null) {
//       if (message.isNotEmpty) {
//         Fluttertoast.showToast(msg: "TEXT");
//         speechStarted = true;
//         var result = await flutterTts?.speak(message);
//         if (result == 1) setState(() => ttsState = TtsState.playing);
//       }
//     } else {
//       Fluttertoast.showToast(msg: "eMTPy TEXT");
//     }
//   }
//
//   /// Each time to start a speech recognition session
//   Future _startListening() async {
//     debugPrint("=================================================");
//     await _stopListening();
//     await Future.delayed(const Duration(milliseconds: 50));
//     await _speechToText.listen(
//         onResult: _onSpeechResult,
//         localeId: _selectedLocaleId,
//         cancelOnError: false,
//         partialResults: true,
//         listenMode: ListenMode.dictation);
//     setState(() {
//       _speechEnabled = true;
//     });
//   }
//
//   /// Manually stop the active speech recognition session
//   /// Note that there are also timeouts that each platform enforces
//   /// and the SpeechToText plugin supports setting timeouts on the
//   /// listen method.
//   Future _stopListening() async {
//     setState(() {
//       _speechEnabled = false;
//     });
//     await _speechToText.stop();
//   }
//
//   /// This is the callback that the SpeechToText plugin calls when
//   /// the platform returns recognized words.
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _currentWords = result.recognizedWords;
//     });
//   }
//
//   FlutterTts? flutterTts;
//   TtsState ttsState = TtsState.stopped;
//   double fontsize = 0.0;
//   initTts() {
//     flutterTts = FlutterTts();
//
//     _getLanguages();
//
//     flutterTts?.setStartHandler(() {
//       setState(() {
//         ttsState = TtsState.playing;
//       });
//     });
//
//     flutterTts?.setCompletionHandler(() {
//       setState(() {
//         ttsState = TtsState.stopped;
//         speechStarted = false;
//       });
//     });
//
//     flutterTts?.setErrorHandler((msg) {
//       setState(() {
//         ttsState = TtsState.stopped;
//       });
//     });
//     flutterTts?.stop();
//   }
//
//   bool speechStarted = false;
//   void stopSpeech() {
//     setState(() {
//       speechStarted = false;
//     });
//     flutterTts?.pause();
//   }
//
//   void continueSpeech() async {
//     if (!speechStarted) {
//       speechStarted = true;
//       var result =
//       await flutterTts?.speak(_lastWords.substring(_currentWords.length));
//       if (result == 1) {
//         setState(() => ttsState = TtsState.playing);
//       }
//     }
//   }
//
//   dynamic languages;
//   Future _getLanguages() async {
//     languages = await flutterTts?.getLanguages;
//     if (languages != null) setState(() => languages);
//   }
//
//   onCreatePdf(String content) async {
//     await Text2Pdf.generatePdf(content);
//   }
//
//   // List<String> notes = [];
//   int currentNoteIndex = 0;
//
//   void changeCurrentNoteIndex(int index) {
//     setState(() {
//       currentNoteIndex = index;
//       _lastWords = notes[index];
//     });
//   }
//
//   List<String> notes = [
//     "Page 1 initial text",
//     "Empty document",
//     "Empty document",
//     "Empty document",
//   ];
//   int currentPageIndex = 0;
//   PageController pageController = PageController(initialPage: 0);
//
//   void updateNoteText(String newText) {
//     notes[currentNoteIndex] += newText;
//   }
//
//   int j = 0;
//   String check = "";
//   String title = "";
//   TextEditingController titleController = TextEditingController();
//
//   void _editTitleDialog(BuildContext context, int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             'Info',
//             style: GoogleFonts.cabin(
//               color: Colors.black,
//               fontSize: MediaQuery.of(context).size.width * 0.05,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 8,
//               ),
//               TextFormField(
//                 controller: titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter title',
//                   labelStyle: GoogleFonts.cabin(
//                     color: Colors.black54,
//                     fontSize: MediaQuery.of(context).size.width * 0.04,
//                   ),
//                   hintText: title ?? '', //noteController.notes[index].title,
//                   hintStyle: GoogleFonts.cabin(
//                     color: Colors.black54,
//                     fontSize: MediaQuery.of(context).size.width * 0.04,
//                   ),
//                   border: const OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 elevation: 0,
//               ),
//
//               // textColor: Colors.black,
//               onPressed: () {
//                 if (titleController.text.isNotEmpty) {
//                   setState(() {
//                     // noteController.notes[index].title = titleController.text;
//                     _dbHelper!.updateQuantity(
//                       NotesModel(
//                         id: j,
//                         content: _lastWords.toString(),
//                         title: titleController.text,
//                       ),
//                     );
//                     title = titleController.text;
//                     titleController.text = "";
//                   });
//
//                   Navigator.of(context).pop(); // Close the dialog
//                 } else {
//                   Fluttertoast.showToast(msg: "Please enter title");
//                 }
//               },
//               child: Text(
//                 'OK',
//                 style: GoogleFonts.cabin(
//                   color: Colors.blue,
//                   fontSize: MediaQuery.of(context).size.width * 0.04,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     // fontsize = MediaQuery.of(context).size.width * 0.045;
//     return ChangeNotifierProvider(
//       create: (context) => TextData(),
//       child: Builder(
//         builder: (context) {
//           return Scaffold(
//             drawer: Drawer(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.5,
//                     width: MediaQuery.of(context).size.width * 0.65,
//                     // decoration: BoxDecoration(
//                     //   border: Border.all(color: Colors.black),
//                     // ),
//                     child: FutureBuilder(
//                       future: notesList,
//                       builder:
//                           (context, AsyncSnapshot<List<NotesModel>> snapshot) {
//                         if (snapshot.hasData) {
//                           return snapshot.data!.isEmpty
//                               ? const Center(child: Text("Add document"))
//                               : ListView.builder(
//                             itemCount: snapshot.data?.length,
//                             itemBuilder: (context, index) {
//                               final currentNote = snapshot.data![index];
//                               final isSelected = currentNote.id == j;
//                               return Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Card(
//                                   elevation: 2,
//                                   shape: RoundedRectangleBorder(
//                                     side: const BorderSide(
//                                       color: ui.Color.fromARGB(
//                                           255, 208, 241, 253),
//                                     ),
//                                     borderRadius:
//                                     BorderRadius.circular(15.0),
//                                   ),
//                                   child: ListTile(
//                                     shape: RoundedRectangleBorder(
//                                       // side: const BorderSide(
//                                       //   color: Colors.black54,
//                                       //   // width: 0.4,
//                                       // ),
//                                       borderRadius:
//                                       BorderRadius.circular(20),
//                                     ),
//                                     title: Text(
//                                       snapshot.data![index].title
//                                           .toString(),
//                                       style: GoogleFonts.cabin(
//                                         color: // Colors.black,
//                                         isSelected
//                                             ? Colors.blue
//                                             : Colors.black,
//                                       ),
//                                     ),
//                                     subtitle: snapshot
//                                         .data![index].content
//                                         .toString()
//                                         .isEmpty
//                                         ? Text(
//                                       "Empty document",
//                                       style: GoogleFonts.cabin(
//                                         // color: Colors.black54,
//                                         color: isSelected
//                                             ? Colors.blue
//                                             : Colors.black54,
//                                       ),
//                                     )
//                                         : Row(
//                                       children: [
//                                         Flexible(
//                                           child: RichText(
//                                             overflow: TextOverflow
//                                                 .ellipsis,
//                                             strutStyle:
//                                             const StrutStyle(
//                                                 fontSize: 12.0),
//                                             text: TextSpan(
//                                               style:
//                                               GoogleFonts.cabin(
//                                                 // color: Colors.black,
//                                                 color: isSelected
//                                                     ? Colors.blue
//                                                     : Colors
//                                                     .black54,
//                                               ),
//                                               text: snapshot
//                                                   .data![index]
//                                                   .content
//                                                   .toString(),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     // Text(
//                                     //   "${snapshot.data![index].content.toString().substring(0, 15)}...",
//                                     //   style: GoogleFonts.cabin(
//                                     //     // color: Colors.black,
//                                     //     color: isSelected
//                                     //         ? Colors.blue
//                                     //         : Colors.black54,
//                                     //   ),
//                                     // ),
//                                     // notes[index].toString().length < 15
//                                     //     ? Text(
//                                     //         notes[index],
//                                     //         style: GoogleFonts.cabin(
//                                     //             color: Colors.black),
//                                     //       )
//                                     //     : Text(
//                                     //         "${notes[index].toString().substring(0, 10)}...",
//                                     //         style: GoogleFonts.cabin(
//                                     //             color: Colors.black),
//                                     //       ),
//                                     onTap: () {
//                                       setState(() {
//                                         _lastWords =
//                                             snapshot.data![index].content;
//                                         j = snapshot.data![index].id!;
//                                         check =
//                                             snapshot.data![index].title;
//                                         title =
//                                             snapshot.data![index].title;
//                                       });
//
//                                       // changeCurrentNoteIndex(index);
//                                       // Optionally close the Drawer after changing the note
//                                       Navigator.pop(context);
//                                     },
//                                     trailing: IconButton(
//                                       padding: EdgeInsets.zero,
//                                       constraints: const BoxConstraints(),
//                                       onPressed: () {
//                                         setState(() {
//                                           _dbHelper!.deleteProduct(
//                                               snapshot.data![index].id!);
//                                           notesList = _dbHelper!
//                                               .getCartListWithUserId();
//                                           if (j ==
//                                               snapshot.data![index].id) {
//                                             _lastWords =
//                                             ''; // Reset the displayed content
//                                             j = -1; // Reset the note ID
//                                             check = ''; // Reset the title
//                                             title = ''; // Reset the title
//                                           }
//                                           snapshot.data!.remove(
//                                               snapshot.data![index]);
//                                         });
//                                       },
//                                       icon: const Icon(
//                                         Icons.close,
//                                         // color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         } else {
//                           return const CircularProgressIndicator();
//                         }
//                       },
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       _dbHelper!
//                           .insert(
//                         NotesModel(content: "", title: "New document"),
//                       )
//                           .then((value) {
//                         print("data added");
//                         setState(() {
//                           notesList = _dbHelper!.getCartListWithUserId();
//                         });
//                       }).onError((error, stackTrace) {
//                         print(
//                           error.toString(),
//                         );
//                       });
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.add),
//                         Text(
//                           'New document',
//                           style: GoogleFonts.cabin(
//                             color: Colors.black,
//                             fontSize: MediaQuery.of(context).size.width * 0.045,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                       const ui.Color.fromARGB(255, 68, 138, 196),
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10),
//                         ),
//                       ),
//                     ),
//                     onPressed: () async {
//
//                       final result = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const ImportPDFScreen()),
//                       );
//                       if (result != null) {
//                         Fluttertoast.showToast(msg: "PDFIF");
//                         setState(() {
//                           _lastWords = result.toString();
//                           // final updatedNote = widget.note?.copyWith(
//                           //       title:
//                           //           "${_lastWords.toString().substring(0, 10)}.....",
//                           //       content: _lastWords,
//                           //       createdDateTime:
//                           //           dateTimenow.toString().substring(0, 16),
//                           //     ) ??
//                           //     Note(
//                           //       title: _lastWords.toString().length > 4
//                           //           ? "${_lastWords.toString().substring(0, 10)}....."
//                           //           : "${_lastWords.toString().substring(0, 4)}.....",
//                           //       content: _lastWords,
//                           //       createdDateTime:
//                           //           dateTimenow.toString().substring(0, 16),
//                           //     );
//                           // widget.onNoteSaved(updatedNote);
//                         });
//                       }
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Import',
//                             style: GoogleFonts.cabin(
//                               color: Colors.white,
//                               fontSize:
//                               MediaQuery.of(context).size.width * 0.055,
//                             ),
//                           ),
//                           const Icon(
//                             Icons.download_rounded,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                       const ui.Color.fromARGB(255, 68, 138, 196),
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10),
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       if (_lastWords.isNotEmpty) onCreatePdf(_lastWords);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Export',
//                             style: GoogleFonts.cabin(
//                               color: Colors.white,
//                               fontSize:
//                               MediaQuery.of(context).size.width * 0.055,
//                             ),
//                           ),
//                           const Icon(
//                             Icons.upload,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             appBar: AppBar(
//               title: Text(
//                 'Write by voice',
//                 style: GoogleFonts.cabin(color: Colors.black),
//               ),
//               backgroundColor: Colors.white,
//               elevation: 0,
//               actions: [
//                 IconButton(
//                   onPressed: () {
//                     // updateNoteText(_lastWords);
//                     if (check.isNotEmpty) {
//                       _dbHelper!.updateQuantity(
//                         NotesModel(
//                             id: j,
//                             content: _lastWords.toString(),
//                             title: title.isEmpty ? "No title" : title),
//                       );
//                       setState(() {
//                         notesList = _dbHelper!.getCartListWithUserId();
//                       });
//                       Fluttertoast.showToast(msg: "Successfully saved");
//                     } else {
//                       Fluttertoast.showToast(msg: "Choose a document");
//                     }
//                   },
//                   icon: const Icon(
//                     Icons.save,
//                     color: Colors.black,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () async {
//                     if (_lastWords.isNotEmpty) {
//                       speechStarted == true ? stopSpeech() : continueSpeech();
//                       // Fluttertoast.showToast(msg: msg);
//                     } else {
//                       Fluttertoast.showToast(msg: "Nothing to say");
//                       // _speak("Please say something");
//                     }
//                   },
//                   icon: Icon(
//                     speechStarted == false ? Icons.play_arrow : Icons.stop,
//                     color: Colors.black,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: ((context) {
//                           return SettingsScreen(
//                             textSize: fontsize == 0
//                                 ? MediaQuery.of(context).size.width * 0.045
//                                 : fontsize,
//                           );
//                         }),
//                       ),
//                     );
//                     if (result != null && result != 0) {
//                       print("INSIDEIF:$result");
//                       setState(() {
//                         fontsize = result;
//                       });
//                       Provider.of<TextData>(context, listen: false)
//                           .setSize(result);
//                     }
//                   },
//                   icon: const Icon(
//                     Icons.settings_outlined,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//               ],
//             ),
//             body: Consumer<TextData>(
//               builder: (context, provider, child) {
//                 // provider.textsizeP = fontsize;
//                 return Column(
//                   // mainAxisSize: MainAxisSize.min,
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           title.isEmpty
//                               ? Text(
//                             "No title",
//                             style: GoogleFonts.cabin(
//                                 color: Colors.black, fontSize: 20.0),
//                             // style: TextStyle(fontSize: 20.0),
//                           )
//                               : Text(
//                             title,
//                             style: GoogleFonts.cabin(
//                                 color: Colors.black, fontSize: 20.0),
//                             // style: TextStyle(fontSize: 20.0),
//                           ),
//                           check.isEmpty
//                               ? const Visibility(
//                             visible: false,
//                             child: Text(''),
//                           )
//                               : IconButton(
//                             onPressed: () {
//                               _editTitleDialog(context, j);
//                             },
//                             icon: Icon(
//                               Icons.edit,
//                               size: MediaQuery.of(context).size.width *
//                                   0.05,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         child: SingleChildScrollView(
//                           child:
//                           // Text(
//                           //   //notes[currentPageIndex],
//                           //   _lastWords,
//                           //   style: GoogleFonts.cabin(
//                           //     color: _lastWords.isNotEmpty
//                           //         ? Colors.black
//                           //         : Colors.black54,
//                           //     fontSize: provider.textsizeP == 0
//                           //         ? MediaQuery.of(context).size.width * 0.045
//                           //         : provider.textsizeP, //fontsize,
//                           //   ),
//                           // ),
//
//                           Text(
//                             _lastWords.isNotEmpty
//                                 ? '$_lastWords $_currentWords'
//                                 : _speechAvailable
//                                 ? check.isEmpty
//                                 ? 'Create or Choose a document'
//                                 : 'Tap the microphone to start listening...'
//                                 : 'Speech not available',
//                             style: GoogleFonts.cabin(
//                               color: _lastWords.isNotEmpty
//                                   ? Colors.black
//                                   : Colors.black54,
//                               fontSize: provider.textsizeP == 0
//                                   ? MediaQuery.of(context).size.width * 0.045
//                                   : provider.textsizeP, //fontsize,
//                             ), //provider.textsizeP),
//                             textAlign: TextAlign.left,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         height: MediaQuery.of(context).size.height * 0.15,
//                         width: MediaQuery.of(context).size.width,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(25),
//                           color: const Color.fromARGB(255, 205, 225, 241),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             PopupMenuButton<int>(
//                               offset: const Offset(30, 50),
//                               // color: const Color.fromARGB(255, 244, 194, 191),
//
//                               shape: const TooltipShape(),
//                               key: _key,
//                               itemBuilder: (context) {
//                                 return <PopupMenuEntry<int>>[
//                                   PopupMenuItem(
//                                     // height: 200,
//                                     value: 0,
//                                     // height: 200,
//                                     child: InkWell(
//                                       child: buildCopyButton(),
//                                       onTap: () {
//                                         Clipboard.setData(
//                                           ClipboardData(text: _lastWords),
//                                         );
//                                         Fluttertoast.showToast(
//                                             msg: 'Text Copied');
//                                       },
//                                     ),
//                                   ),
//                                   PopupMenuItem(
//                                     value: 3,
//                                     child: InkWell(
//                                       onTap: () async {
//                                         // setState(() {
//                                         //   _lastWords = "";
//                                         // });
//                                         // _showInfoDialog(context);
//                                         ClipboardData? data =
//                                         await Clipboard.getData(
//                                             'text/plain');
//                                         // debugPrint(data!.text);
//                                         String? temp = "";
//                                         setState(() {
//                                           temp = data!.text;
//                                           _lastWords += temp!;
//                                           _lastWords += " ";
//                                         });
//
//                                         Fluttertoast.showToast(msg: 'Pasted');
//                                       },
//                                       child: const ListTile(
//                                         leading: Icon(Icons.paste),
//                                         title: Text('Paste'),
//                                       ),
//                                     ),
//                                   ),
//                                   // PopupMenuItem(child: Text('1'), value: 1),
//                                   PopupMenuItem(
//                                     value: 1,
//                                     child: InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           _lastWords = "";
//                                         });
//
//                                         Fluttertoast.showToast(
//                                             msg: 'Text Cleared');
//                                       },
//                                       child: const ListTile(
//                                         leading: Icon(
//                                             Icons.cleaning_services_outlined),
//                                         title: Text('Clear'),
//                                       ),
//                                     ),
//                                   ),
//                                   PopupMenuItem(
//                                     value: 2,
//                                     child: InkWell(
//                                       onTap: () {
//                                         // setState(() {
//                                         //   _lastWords = "";
//                                         // });
//                                         _showInfoDialog(context);
//                                         Fluttertoast.showToast(msg: 'Info');
//                                       },
//                                       child: const ListTile(
//                                         leading: Icon(Icons.info_outline),
//                                         title: Text('Info'),
//                                       ),
//                                     ),
//                                   ),
//                                   PopupMenuItem(
//                                     value: 4,
//                                     child: InkWell(
//                                       onTap: () {
//                                         // setState(() {
//                                         //   _lastWords = "";
//                                         // });
//                                         Fluttertoast.showToast(msg: "Listen");
//                                         if (_lastWords.isNotEmpty) {
//                                           _speak(_lastWords);
//                                         } else {
//                                           _speak("First say something");
//                                         }
//                                         // Fluttertoast.showToast(
//                                         //     msg: 'Text Cleared');
//                                       },
//                                       child: const ListTile(
//                                         leading: Icon(Icons.speaker),
//                                         title: Text('Listen'),
//                                       ),
//                                     ),
//                                   ),
//                                 ];
//                               },
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 if (_lastWords.isNotEmpty) {
//                                   // Split the string into words
//                                   List<String> words = _lastWords.split(' ');
//
//                                   if (words.isNotEmpty) {
//                                     // Remove the last word
//                                     _removedWords.add(words.removeLast());
//                                     // words.removeLast();
//
//                                     // Reconstruct the string with the modified words
//                                     setState(() {
//                                       _lastWords = words.join(' ');
//                                     });
//                                   }
//                                 }
//                               },
//                               icon: const Icon(Icons.undo),
//                             ),
//                             InkWell(
//                               onTap:
//                               // () {
//                               //   // print("VA/LUE:${provider.textsizeP}");
//                               //   provider.printSize();
//                               //   print("GETTER:${provider.sizee}");
//                               // },
//                               _speechToText.isNotListening
//                                   ? _startListening
//                                   : _stopListening,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   // horizontal: MediaQuery.of(context).size.width * 0.4,
//                                   vertical:
//                                   20, //MediaQuery.of(context).size.width * 0.15,
//                                 ),
//                                 child: Container(
//                                   height:
//                                   MediaQuery.of(context).size.width * 0.15,
//                                   width:
//                                   MediaQuery.of(context).size.width * 0.15,
//                                   decoration: BoxDecoration(
//                                     color:
//                                     const Color.fromARGB(255, 39, 97, 177),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Icon(
//                                     _speechToText.isNotListening
//                                         ? Icons.mic
//                                         : Icons.square,
//                                     color: Colors.white,
//                                     size: MediaQuery.of(context).size.width *
//                                         0.09,
//                                   ),
//                                   // Icon(
//                                   //   Icons.mic,
//                                   //   color: Colors.white,
//                                   //   size: MediaQuery.of(context).size.width * 0.1,
//                                   // ),
//                                 ),
//                               ),
//                             ),
//                             // IconButton(
//                             //   onPressed: () {
//                             //     if (_lastWords.isNotEmpty) {
//                             //       // Split the string by lines
//                             //       List<String> lines = _lastWords.split('\n');
//
//                             //       // Get the last line
//                             //       String lastLine = lines.last;
//
//                             //       if (lastLine.isNotEmpty) {
//                             //         // Remove the last character from the last line
//                             //         lastLine =
//                             //             lastLine.substring(0, lastLine.length - 1);
//                             //         lines[lines.length - 1] = lastLine;
//
//                             //         // Reconstruct the string with modified last line
//                             //         setState(() {
//                             //           _lastWords = lines.join('\n');
//                             //         });
//                             //       } else {
//                             //         // If the last line is empty, remove the entire line
//                             //         lines.removeLast();
//                             //         setState(() {
//                             //           _lastWords = lines.join('\n');
//                             //         });
//                             //       }
//                             //     }
//                             //   },
//                             //   icon: Icon(Icons.backspace),
//                             // ),
//                             IconButton(
//                               onPressed: () {
//                                 if (_removedWords.isNotEmpty) {
//                                   // Restore the previously removed word
//                                   String restoredWord =
//                                   _removedWords.removeLast();
//                                   setState(() {
//                                     _lastWords +=
//                                     ' $restoredWord'; // Add space and the restored word
//                                   });
//                                 }
//                               },
//                               icon: _removedWords.isNotEmpty
//                                   ? const Icon(Icons.redo)
//                                   : const Icon(
//                                 Icons.redo,
//                                 color: Colors.black26,
//                               ),
//                             ),
//                             Container(
//                               height: MediaQuery.of(context).size.width * 0.15,
//                               width: MediaQuery.of(context).size.width * 0.15,
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(255, 156, 177, 39),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: IconButton(
//                                 onPressed: () async {
//                                   String textToSend = "";
//                                   if (_lastWords.isNotEmpty) {
//                                     Fluttertoast.showToast(msg: "Sending");
//
//                                     // textToSend =
//                                     //     'https://wa.me/?text=${Uri.encodeComponent(_lastWords)}';
//                                     // 'https://wa.me/?text=Check out my location: https://maps.google.com/maps?q=$latitudes,$longitudes';
//
//                                     // Open the URL with the textToSend included
//                                     // _launchWhatsApp(textToSend);
//
//                                     await Share.share(_lastWords);
//                                   } else {
//                                     Fluttertoast.showToast(msg: "Empty text");
//                                   }
//                                 },
//                                 icon: const Icon(Icons.send),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Align(
//                     //   alignment: Alignment.bottomLeft,
//                     //   child: Padding(
//                     //     padding: EdgeInsets.symmetric(
//                     //       horizontal: MediaQuery.of(context).size.width * 0.1,
//                     //       vertical: MediaQuery.of(context).size.width * 0.1,
//                     //     ),
//                     //     child: ElevatedButton(
//                     //       onPressed: () {
//                     //         if (currentPageIndex > 0) {
//                     //           currentPageIndex--;
//                     //           pageController.animateToPage(currentPageIndex,
//                     //               duration: Duration(milliseconds: 300),
//                     //               curve: Curves.ease);
//                     //         }
//                     //       },
//                     //       child: Text("Previous Page"),
//                     //     ),
//                     //   ),
//                     // ),
//                     // Align(
//                     //   alignment: Alignment.bottomLeft,
//                     //   child: Padding(
//                     //     padding: EdgeInsets.symmetric(
//                     //       horizontal: MediaQuery.of(context).size.width * 0.1,
//                     //       vertical: MediaQuery.of(context).size.width * 0.1,
//                     //     ),
//                     //     child: ElevatedButton(
//                     //       onPressed: () {
//                     //         if (currentPageIndex < notes.length - 1) {
//                     //           currentPageIndex++;
//                     //           pageController.animateToPage(currentPageIndex,
//                     //               duration: Duration(milliseconds: 300),
//                     //               curve: Curves.ease);
//                     //         }
//                     //       },
//                     //       child: Text("Next Page"),
//                     //     ),
//                     //   ),
//                     // ),
//                     // Align(
//                     //   alignment: Alignment.bottomLeft,
//                     //   child: Padding(
//                     //     padding: EdgeInsets.symmetric(
//                     //       horizontal: MediaQuery.of(context).size.width * 0.1,
//                     //       vertical: MediaQuery.of(context).size.width * 0.1,
//                     //     ),
//                     //     child: ElevatedButton(
//                     //       onPressed: () {
//                     //         notes.add("New page text");
//                     //         currentPageIndex =
//                     //             notes.length - 1; // Switch to the new page
//                     //         pageController.jumpToPage(currentPageIndex);
//                     //       },
//                     //       child: Text("New Page"),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 );
//               },
//             ),
//             // floatingActionButton: FloatingActionButton(
//             //   onPressed:
//             //       _speechToText.isNotListening ? _startListening : _stopListening,
//             //   tooltip: 'Listen',
//             //   child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
//             // ),
//           );
//         },
//       ),
//       // ),
//     );
//   }
//
//   // _launchWhatsApp(String url) async {
//   //   if (await canLaunchUrl(Uri.parse(url))) {
//   //     await launchUrl(Uri.parse(url));
//   //   } else {
//   //     throw 'Could not launch $url';
//   //   }
//   // }
//
//   Widget buildCopyButton() {
//     return ListTile(
//       leading: const Icon(Icons.copy_all),
//       title: Text(
//         "Copy all",
//         style: GoogleFonts.cabin(
//           color: Colors.black,
//           fontSize: MediaQuery.of(context).size.width * 0.04,
//         ),
//       ),
//     );
//   }
//
//   void _showInfoDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             'Info',
//             style: GoogleFonts.cabin(
//               color: Colors.black,
//               fontSize: MediaQuery.of(context).size.width * 0.05,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Creation date:',
//                 style: GoogleFonts.cabin(
//                   color: Colors.black54,
//                   fontSize: MediaQuery.of(context).size.width * 0.045,
//                 ),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               Text(
//                 'Words count: ${wordCount(_lastWords)}',
//                 style: GoogleFonts.cabin(
//                   color: Colors.black54,
//                   fontSize: MediaQuery.of(context).size.width * 0.045,
//                 ),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               Text(
//                 'Characters count: ${charCount(_lastWords)}',
//                 style: GoogleFonts.cabin(
//                   color: Colors.black54,
//                   fontSize: MediaQuery.of(context).size.width * 0.045,
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 elevation: 0,
//               ),
//
//               // textColor: Colors.black,
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text(
//                 'OK',
//                 style: GoogleFonts.cabin(
//                   color: Colors.blue,
//                   fontSize: MediaQuery.of(context).size.width * 0.04,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//

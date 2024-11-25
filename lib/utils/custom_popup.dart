import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../main.dart';
import 'appcolors.dart';

class CustomExitLogoutPopup extends StatelessWidget {
  final VoidCallback onLogout;
  const CustomExitLogoutPopup({Key? key, required this.onLogout}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border:
                    Border.all(color: AppColor.instanse.borderWhite, width: 1),
                gradient: LinearGradient(
                  colors: [
                    AppColor.instanse.blurColor.withOpacity(0.8),
                    AppColor.instanse.containerGradient.withOpacity(0.8)
                  ],
                  stops: const [0.0, 1.0],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Are You Sure?", style: aa.alabelStyle),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          onLogout();
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
                          child: Text("Log out", style: aa.newText),
                        ),
                      ),
                      InkWell(
                        onTap: () => exit(0),
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
                                ]),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Text("Exit App", style: aa.abhintStyle),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -15,
              right: -15,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class CustomOnlyExitPopup extends StatelessWidget {
  const CustomOnlyExitPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border:
                Border.all(color: AppColor.instanse.borderWhite, width: 1),
                gradient: LinearGradient(
                  colors: [
                    AppColor.instanse.blurColor.withOpacity(0.8),
                    AppColor.instanse.containerGradient.withOpacity(0.8)
                  ],
                  stops: const [0.0, 1.0],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Are You Sure?", style: aa.alabelStyle),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => exit(0),
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
                            ]),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Text("Exit App", style: aa.abhintStyle),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -15,
              right: -15,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
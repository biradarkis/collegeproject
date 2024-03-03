import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereismykid/src/constants/Roles.dart';
import 'package:flutter/material.dart';
import 'package:whereismykid/src/constants/textconstants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whereismykid/src/main_screen/choose_driver.dart';

class ChooseRole extends StatefulWidget {
  static const String routeName = "choose_role";
  const ChooseRole({super.key});

  @override
  State<ChooseRole> createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool isLoading = false;
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  Future<void> _handleSaveClick() async {
    setState(() {
      isLoading = true;
    });
    if (_character == Role.Driver) {
      var status = await Permission.location.status;
      if (!status.isGranted) {
        await [Permission.location].request();
        status = await Permission.location.status;
      }

      if (status.isGranted) {
        const snackBar = SnackBar(
          content: Text('Please turn on GPS to start using the app...'),
          margin: EdgeInsets.only(bottom: 40),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(
          content:
              Text('Without location permission this app cannot be used....'),
          margin: EdgeInsets.only(bottom: 40),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await openAppSettings();
        return;
      }
    }

    var pref = await prefs;
    try {
      final response = await http.post(
        Uri.parse(TextConstants.apiBaseUrl + TextConstants.postUser),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Redirect': 'follow'
        },
        body: jsonEncode(<String, String>{
          'Name': pref.getString("UserName") ?? "",
          'email': pref.getString("UserEmail") ?? "",
          'Role': _character == Role.Driver ? "Driver" : "User"
        }),
      );
      var issuccess = jsonDecode(response.body)["success"] == true;
      var existingUser = (jsonDecode(response.body)["errorMessage"] as String?)
          ?.contains("User Already Exists");
      logger.d(response.body);

      if (response.statusCode == 200 && issuccess ||
          (existingUser != null && existingUser)) {
        // const snackBar = SnackBar(
        //   content: Text('User Successfully Added...'),
        //   margin: EdgeInsets.only(bottom: 40),
        //   behavior: SnackBarBehavior.floating,
        //   duration: Duration(milliseconds: 700),
        // );
        setState(() {
          isLoading = false;
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(snackBar)
          //     .closed
          //     .then((value) {
          if (_character == Role.User) {
            Navigator.pushReplacementNamed(context, ChooseDriver.routeName);
          }
          // }
        });
      } else {
        setState(() {
          const snackBar = SnackBar(
            content: Scaffold(
              body: Text('Something went wrong at the server...'),
            ),
            margin: EdgeInsets.only(bottom: 40),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          isLoading = false;
        });
      }
    } catch (e) {
      logger.e("Error occuredd!!!!");
      logger.d(e);
    }
  }

  Role? _character = Role.User;

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  text: const TextSpan(
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                      children: [TextSpan(text: TextConstants.choose_role)]),
                ),
                Center(
                    child: ListTile(
                  title: const Text('User/ Parent'),
                  leading: Radio<Role>(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.yellow),
                    value: Role.User,
                    groupValue: _character,
                    onChanged: (Role? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                )),
                Center(
                    child: ListTile(
                  title: const Text('Driver'),
                  leading: Radio<Role>(
                    value: Role.Driver,
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => Colors.yellow),
                    groupValue: _character,
                    onChanged: (Role? value) {
                      setState(() {
                        const snackBar = SnackBar(
                            content:
                                Text('location permission required for driver'),
                            margin: EdgeInsets.only(bottom: 40),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 1));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        _character = value;
                      });
                    },
                  ),
                )),
                GFButton(
                  onPressed: _handleSaveClick,
                  text: TextConstants.save,
                  color: Colors.yellow,
                  textColor: Colors.black,
                )
              ],
            ))
        : LoadingAnimationWidget.flickr(
            leftDotColor: Colors.white,
            rightDotColor: Colors.yellow,
            size: MediaQuery.of(context).size.width * 0.3);
  }
}

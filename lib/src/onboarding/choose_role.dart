import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereismykid/src/constants/Roles.dart';
import 'package:flutter/material.dart';
import 'package:whereismykid/src/constants/textconstants.dart';

class ChooseRole extends StatefulWidget {
  static const String routeName = "choose_role";
  const ChooseRole({super.key});

  @override
  State<ChooseRole> createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  final client = HttpClient();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool isLoading = false;
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  void _handleSaveClick() async {
    if (_character == Role.Driver) {}

    var pref = await prefs;
    logger.d(pref.getString("UserName"));
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
                        );

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
        : LoadingAnimationWidget.dotsTriangle(
            color: Colors.white, size: MediaQuery.of(context).size.width * 0.5);
  }
}

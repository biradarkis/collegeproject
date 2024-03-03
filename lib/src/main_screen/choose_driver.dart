import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereismykid/src/constants/textconstants.dart';
import 'package:http/http.dart' as http;
import 'package:whereismykid/src/records/user.dart';

class ChooseDriver extends StatefulWidget {
  static const routeName = 'chooseDriver';
  const ChooseDriver({super.key});
  @override
  State<ChooseDriver> createState() => ChooseDriverState();
}

class ChooseDriverState extends State<ChooseDriver> {
  Future<SharedPreferences> prefsfuture = SharedPreferences.getInstance();
  SharedPreferences? prefs;
  var selectedDriverEmail = "";
  final Logger logger = Logger(printer: PrettyPrinter());
  Widget selectionhint = const Text(
    TextConstants.noDriverSelected,
    style: TextStyle(color: Colors.black),
  );
  List<DropdownMenuItem<String>> items = [];
  dynamic image;
  String userName = "";
  @override
  void initState() {
    super.initState();
    _getImage();
    _getDriversItems();
  }

  _getDriversItems() {
    String response;
    http.get(Uri.parse(TextConstants.apiBaseUrl + TextConstants.getDrivers),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }).then((value) {
      response = value.body;

      if (value.statusCode != 200) {
        const snackBar = SnackBar(
          content: Text('Something went wrong at the server...'),
          margin: EdgeInsets.only(bottom: 40),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      logger.d(response);
      var users = List<User>.from((jsonDecode(response) as List<dynamic>)
          .map((e) => User.fromJson(e))
          .toList());
      setState(() {
        items = users
            .map((e) => DropdownMenuItem(
                value: e.name,
                child:
                    Text(e.name, style: const TextStyle(color: Colors.white))))
            .toList();
      });
    });
  }

  _getImage() {
    String? url;

    prefsfuture.then((value) {
      prefs = value;
      return value.getString("PhotoUrl");
    }).then((value) {
      url = value;
      logger.d(url);
      setState(() {
        userName = prefs?.getString("UserName")?.split(' ')[0] ?? "";
        logger.d(userName);
        logger.d("loggin username...........");

        if (url != null && url!.isNotEmpty) {
          image = NetworkImage(url ?? "");
        } else {
          image = const AssetImage("assets/images/defaultuseravtar.png");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: const EdgeInsets.fromLTRB(5, 40, 5, 20),
          child: Column(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          child: RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                  color: Color.fromRGBO(85, 85, 85, 1.0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  const TextSpan(text: "Hello,\n"),
                                  TextSpan(text: userName.trim()),
                                ]),
                          )),
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Color.fromARGB(255, 240, 235, 235),
                                spreadRadius: 3)
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: image,
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: const EdgeInsets.all(30),
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text: TextConstants.selectDriver,
                              style: TextStyle(
                                  color: Color.fromRGBO(85, 85, 85, 1.0),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500))
                        ]),
                      ),
                    ),
                    Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: SizedBox(
                            height: 10,
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButtonHideUnderline(
                              child: GFDropdown(
                                items: items,
                                onChanged: (s) {
                                  setState(() {
                                    selectionhint = Text(s ?? "",
                                        style: const TextStyle(
                                            color: Colors.black));
                                  });
                                },
                                elevation: 3,
                                dropdownButtonColor: Colors.yellow,
                                icon: const Icon(Icons.drive_eta_rounded,
                                    color: Colors.black),
                                hint: selectionhint,
                              ),
                            )))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereismykid/src/constants/textconstants.dart';

class ChooseDriver extends StatefulWidget {
  static const routeName = 'chooseDriver';
  const ChooseDriver({super.key});
  @override
  State<ChooseDriver> createState() => ChooseDriverState();
}

class ChooseDriverState extends State<ChooseDriver> {
  Future<SharedPreferences> prefsfuture = SharedPreferences.getInstance();
  SharedPreferences? prefs;
 var selectedDriverEmail  = "";
 Widget selectionhint = Text("Select a driver");
 List<Widget>  items  =
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  dynamic image;
  String userName = "";
  @override
  void initState() {
    _getImage();
    super.initState();
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
          logger.wtf("what the fuck logger");
          image = NetworkImage(url ?? "");
        } else {
          image = const AssetImage("assets/images/defaultuseravtar.png");
        }
      });
    });

    super.initState();
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
                      child: GFDropdown(items: const [
                        DropdownMenuItem(
                          value: "Kris1",
                          child: Text("fsfssf1"),
                        ),DropdownMenuItem(
                          value: "Kris2",
                          child: Text("2fsfssf"),
                        ),DropdownMenuItem(
                          value: "Kris22",
                          child: Text("f22sfssf"),
                        ),DropdownMenuItem(
                          value: "Kris22",
                          child: Text("f22sfssf"),
                        )
                      ], onChanged: (s) {},
                      elevation:3 ,
                      dropdownButtonColor: Colors.yellow,
                      icon: const Icon(Icons.drive_eta_rounded,
                      color: Colors.black),
                      hint: const Text(TextConstants.selectDriver,style: TextStyle(
                        color: Colors.black
),
),
),
)
],
                ),
              )
            ],
          ),
        ));
  }

 List<DropdownMenuItem> _getDriversItems() async{
      var client   =  HttpClient();
  var a =   await client.get("",1,"")
  a.done.ma

  }
}

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereismykid/src/onboarding/choose_role.dart';
import 'package:whereismykid/src/onboarding/google_signup_service.dart';
import '../constants/textconstants.dart';
import 'package:logger/logger.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});
  @override
  State<LoginWidget> createState() {
    return LoginWidgetState();
  }
}

class LoginWidgetState extends State<LoginWidget> {
  bool isLoading = false;

  var logger = Logger(
    printer: PrettyPrinter(),
  );
  final FirebaseService _firebaseService = FirebaseService();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleSignupClick() async {
    setState(() {
      isLoading = true;
    });
    var res = await _firebaseService.signInwithGoogle();

   
    if (res != null) {
      var pref = await _prefs;

      await pref.setString("UserName", res.displayName ?? "");
      await pref.setString("UserEmail", res.email);
      await pref.setString("GoogleId", res.id);
      await pref.setString("PhotoUrl", res.photoUrl  ?? "");
      await Navigator.pushReplacementNamed(context, ChooseRole.routeName);
    }
     setState(() {
      isLoading = false;
    });

    scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
      content: Text("Error Signing up...."),
    ));
  }

  Future<void> _handleSignOutClick() async {
    await _firebaseService.signOutFromGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
           const Text(
              TextConstants.appname,
              textAlign: TextAlign.center,
              style:  TextStyle(
                  color: Color.fromARGB(255, 12, 181, 203),
                  decoration: TextDecoration.none,
                  fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                "assets/images/google-maps-pin.png",
                height: 50,
                width: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  onPressed: _handleSignupClick,
                  child: const Text(
                    "Sign Up With Google",
                    style: TextStyle(color: Colors.black),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  onPressed: _handleSignOutClick,
                  child: const Text(
                    "Sign In",
                    style: TextStyle(color: Colors.black),
                  )),
            )
          ])
        : LoadingAnimationWidget.dotsTriangle(
            color: Colors.white, size: MediaQuery.of(context).size.width * 0.5);
  }
}

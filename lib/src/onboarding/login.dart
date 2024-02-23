import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});
  @override
  State<LoginWidget> createState() {
    return LoginWidgetState();
  }
}

class LoginWidgetState extends State<LoginWidget> {
  List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  GoogleSignIn signIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
    signInOption: SignInOption.standard,
  );
  @override
  void initState() {
    signIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
// #docregion CanAccessScopes
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, on web...
      if (account != null) {
        isAuthorized = await signIn.canAccessScopes(scopes);
      }
// #enddocregion CanAccessScopes
super.initState();
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
        print(_currentUser?.displayName);
        print("KRIS");
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text(
        "WHERE IS MY KID",
        textAlign: TextAlign.center,
        style: TextStyle(
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
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
            onPressed: () async {
              await signIn.signIn();
              print(_currentUser?.displayName);
              print(_currentUser?.displayName);
              print("GOOGLEE");
            },
            child: const Text(
              "Sign Up With Google",
              style: TextStyle(color: Colors.black),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 100),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
            onPressed: () {},
            child: const Text(
              "Sign In",
              style: TextStyle(color: Colors.black),
            )),
      )
    ]);
  }
}

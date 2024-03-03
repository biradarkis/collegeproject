import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereismykid/src/main_screen/choose_driver.dart';
import 'package:whereismykid/src/onboarding/choose_role.dart';
import 'package:whereismykid/src/onboarding/login.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.

class MyApp extends StatefulWidget {
  const MyApp(
      {super.key,
      required this.settingsController,
      required this.sharedPreferences});

  final SettingsController settingsController;
  final SharedPreferences sharedPreferences;

  @override
  // ignore: no_logic_in_create_state
  State<MyApp> createState() => _MyAppState(
      settingsController: settingsController,
      sharedPreferences: sharedPreferences);
}

class _MyAppState extends State<MyApp> {
  _MyAppState(
      {required this.settingsController, required this.sharedPreferences});

  final SettingsController settingsController;
  final SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
  }

  // ignore: unused_field

  // ignore: unused_field

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',
          debugShowCheckedModeBanner: false,
          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            // ignore: unused_local_variable
            Widget widget = const ChooseDriver();

            var username = sharedPreferences.getString("UserName");
            if (username == null) {
              widget = const LoginWidget();
            }
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case ChooseRole.routeName:
                    return const ChooseRole();
                  case ChooseDriver.routeName:
                    return const ChooseDriver();
                  default:
                    return const LoginWidget();
                }
              },
            );
          },
        );
      },
    );
  }
}

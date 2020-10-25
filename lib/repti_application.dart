/*
   Copyright 2020 Thomas Bonk <thomas@meandmymac.de>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:repti/repti_root_page.dart';

class ReptiApplication extends StatefulWidget {
  @override
  _ReptiApplicationState createState() => _ReptiApplicationState();
}

class _ReptiApplicationState extends State<ReptiApplication> {
  var brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;

  @override
  void initState() {
    super.initState();

    final window = WidgetsBinding.instance.window;

    window.onPlatformBrightnessChanged = () {
      setState(() {
        brightness = window.platformBrightness;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;

    final materialTheme = new ThemeData(
      primarySwatch: Colors.purple,
    );
    final materialDarkTheme = new ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
    );
    final cupertinoTheme = new CupertinoThemeData(
      brightness: brightness,
    );

    return Theme(
      data: brightness == Brightness.light ? materialTheme : materialDarkTheme,
      child: PlatformProvider(
        builder: (context) => PlatformApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          title: 'repti',
          material: (_, __) {
            return new MaterialAppData(
              theme: materialTheme,
              darkTheme: materialDarkTheme,
              themeMode: brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
            );
          },
          cupertino: (_, __) => new CupertinoAppData(
            theme: cupertinoTheme,
          ),
          home: ReptiRootPage(),
        ),
      ),
    );
  }
}

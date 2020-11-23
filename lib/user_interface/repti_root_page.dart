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

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:repti/user_interface/species_list/species_list.dart';

class MasterDetailWidget {
  String get title => "";

  set navigationBar(PlatformAppBar navbar) {}
  PlatformAppBar get navigationBar => null;

  void addedToMasterDetailPage() {}
}

class ReptiRootPage extends StatefulWidget {
  final double _widthBreakpoint;

  ReptiRootPage({
    double widthBreakpoint = 600,
  }) : this._widthBreakpoint = widthBreakpoint;

  @override
  _ReptiRootPage createState() => _ReptiRootPage(
        widthBreakpoint: this._widthBreakpoint,
      );
}

class _ReptiRootPage extends State<ReptiRootPage> {
  final double _widthBreakpoint;

  var _isLargeScreen = false;

  _ReptiRootPage({
    double widthBreakpoint = 600,
  }) : this._widthBreakpoint = widthBreakpoint;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        _isLargeScreen = MediaQuery.of(context).size.width > _widthBreakpoint;

        var detailAppBar = PlatformAppBar(
          title: PlatformText("detailTitle"),
        );

        return Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: SpeciesList((species) {
                print("Selected: ${species}");
              }),
            ),
            _isLargeScreen
                ? Expanded(
                    flex: 7,
                    child: Column(
                      children: <Widget>[
                        detailAppBar,
                        PlatformText("Detail"),
                      ],
                    ),
                  )
                : Container(),
          ],
        );
      }),
    );
  }
}

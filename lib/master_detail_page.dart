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

class MasterDetailWidget {
  String get title => "";

  set navigationBar(PlatformAppBar navbar) {}
  PlatformAppBar get navigationBar => null;

  void addedToMasterDetailPage() {}
}

class MasterDetailPage extends StatefulWidget {
  Widget _master;
  Widget _detail;
  double _widthBreakpoint;

  MasterDetailPage({
    @required Widget master,
    @required Widget detail,
    double widthBreakpoint = 600,
  })  : this._master = master,
        this._detail = detail,
        this._widthBreakpoint = widthBreakpoint;

  @override
  _MasterDetailPageState createState() => _MasterDetailPageState(
        master: this._master,
        detail: this._detail,
        widthBreakpoint: this._widthBreakpoint,
      );
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  Widget _master;
  Widget _detail;
  double _widthBreakpoint;

  var _isLargeScreen = false;

  _MasterDetailPageState({
    @required Widget master,
    @required Widget detail,
    double widthBreakpoint,
  })  : this._master = master,
        this._detail = detail,
        this._widthBreakpoint = widthBreakpoint;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        _isLargeScreen = MediaQuery.of(context).size.width > _widthBreakpoint;

        var masterTitle =
            (_master is MasterDetailWidget) ? (_master as MasterDetailWidget).title : "Master";
        var masterAppBar = PlatformAppBar(
          title: PlatformText(masterTitle),
        );

        if (_master is MasterDetailWidget) {
          (_master as MasterDetailWidget).navigationBar = masterAppBar;
        }

        var detailTitle =
            (_detail is MasterDetailWidget) ? (_detail as MasterDetailWidget).title : "Detail";
        var detailAppBar = PlatformAppBar(
          title: PlatformText(detailTitle),
        );

        if (_detail is MasterDetailWidget) {
          (_detail as MasterDetailWidget).navigationBar = detailAppBar;
        }

        return Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  masterAppBar,
                  _master,
                ],
              ),
            ),
            _isLargeScreen
                ? Expanded(
                    flex: 7,
                    child: Column(
                      children: <Widget>[
                        detailAppBar,
                        _detail,
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

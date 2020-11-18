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

import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:repti/master_detail_page.dart';

// ignore: must_be_immutable
class _DetailsPage extends StatelessWidget implements MasterDetailWidget {
  @override
  PlatformAppBar navigationBar;

  @override
  String get title => "Detail";

  @override
  Widget build(BuildContext context) => PlatformText("Detail");

  @override
  void addedToMasterDetailPage() {
    // TODO: implement addedToMasterDetailPage
  }
}

// ignore: must_be_immutable
class _MasterPage extends StatelessWidget implements MasterDetailWidget {
  @override
  PlatformAppBar navigationBar;

  @override
  String get title => "Master";

  @override
  Widget build(BuildContext context) => PlatformText("Master");

  @override
  void addedToMasterDetailPage() {
    // TODO: implement addedToMasterDetailPage
  }
}

class ReptiRootPage extends MasterDetailPage {
  ReptiRootPage()
      : super(
          master: _MasterPage(),
          detail: _DetailsPage(),
        );
}

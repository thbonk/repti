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

import 'package:repti/model/entities/index.dart';
import 'package:repti/user_interface/master_detail_page.dart';

typedef Null SpeciesSelectedCallback(Species species);

class SpeciesList extends StatefulWidget implements MasterDetailPage {
  SpeciesSelectedCallback speciesSelectedCallback;

  SpeciesList(this.speciesSelectedCallback);

  @override
  State<SpeciesList> createState() {
    // TODO: implement createState
    return _SpeciesListState();
  }
}

class _SpeciesListState extends State<SpeciesList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

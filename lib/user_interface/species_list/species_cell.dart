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
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:repti/model/entities/index.dart';
import 'package:repti/user_interface/colors.dart';

class SpeciesCell extends StatelessWidget {
  final Species species;

  const SpeciesCell(
    this.species, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: ReptiColors.gridColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8, left: 16, top: 16),
            child: PlatformText(
              species.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16, left: 16),
            child: PlatformText(species.scientificName),
          ),
        ],
      ),
    );
  }
}

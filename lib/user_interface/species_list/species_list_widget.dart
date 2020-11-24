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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:repti/model/entities/index.dart';
import 'package:repti/repti_application.dart';
import 'package:repti/user_interface/species_list/species_cell.dart';
import 'package:repti/user_interface/species_list/species_list.dart';

class SpeciesListWidget extends StatefulWidget {
  final SpeciesSelectedCallback _speciesSelectedCallback;

  const SpeciesListWidget(
    this._speciesSelectedCallback, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SpeciesListWidgetState(_speciesSelectedCallback);
  }
}

class _SpeciesListWidgetState extends State<SpeciesListWidget> {
  final SpeciesSelectedCallback _speciesSelectedCallback;

  Future<List<Species>> get species async {
    if (ReptiApplication.shared.database == null) {
      return [];
    }

    return await ReptiApplication.shared.database.speciesDao.findAll();
  }

  _SpeciesListWidgetState(this._speciesSelectedCallback) {
    ReptiApplication.shared.eventBus.on<DatabaseReadyEvent>().listen((event) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done || snap.hasData == null) {
          return Container();
        }

        return ListView.builder(
            itemCount: snap.data.length,
            itemBuilder: (BuildContext context, int index) {
              return snap.data.length == 0
                  ? Center(child: PlatformText("No items"))
                  : GestureDetector(
                      onTap: () => _speciesSelectedCallback(snap.data[index]),
                      child: SpeciesCell(snap.data[index]),
                    );
            });
      },
      future: species,
    );
  }
}

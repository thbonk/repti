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
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:repti/model/entities/index.dart';
import 'package:repti/repti_application.dart';
import 'package:repti/user_interface/colors.dart';
import 'package:repti/user_interface/species_list/species_dialog.dart';
import 'package:repti/user_interface/species_list/species_list_widget.dart';

typedef Null SpeciesSelectedCallback(Species species);

class SpeciesList extends StatefulWidget {
  final SpeciesSelectedCallback speciesSelectedCallback;

  SpeciesList(this.speciesSelectedCallback);

  @override
  State<SpeciesList> createState() {
    return _SpeciesListState(speciesSelectedCallback);
  }
}

class _SpeciesListState extends State<SpeciesList> {
  final _formKey = GlobalKey<FormState>();
  final SpeciesSelectedCallback speciesSelectedCallback;

  _SpeciesListState(this.speciesSelectedCallback) {
    ReptiApplication.shared.eventBus.on<DatabaseReadyEvent>().listen((event) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: false,
      iosContentBottomPadding: false,
      material: (ctx, _) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAlertDialog(context),
          tooltip: "Add Species",
          child: Icon(Icons.add),
        ),
      ),
      appBar: PlatformAppBar(
        automaticallyImplyLeading: false,
        title: PlatformText("Species"),
        cupertino: (ctx, _) => CupertinoNavigationBarData(
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.add),
            onPressed: () => _showAlertDialog(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: ReptiColors.gridColor,
              ),
            ),
          ),
          child: SpeciesListWidget(speciesSelectedCallback),
        ),
      ),
    );
  }

  Future _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final species = Species("", "");

          return SpeciesDialog(formKey: _formKey, species: species);
        });
  }
}

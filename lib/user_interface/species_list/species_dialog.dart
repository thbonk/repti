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
import 'package:repti/repti_application.dart';

class SpeciesDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Species species;

  SpeciesDialog({
    Key key,
    @required this.species,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      content: Stack(
        children: <Widget>[
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: PlatformText(
                    'Add Species',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: FormField(
                    builder: (state) => PlatformTextField(
                      cupertino: (context, platform) => CupertinoTextFieldData(
                        prefix: state.isValid
                            ? null
                            : Tooltip(
                                message: state.errorText ?? "Please enter a name",
                                child: Icon(Icons.error),
                              ),
                        placeholder: "Name",
                      ),
                      material: (context, platform) => MaterialTextFieldData(
                        decoration: InputDecoration(
                          labelText: "Name",
                          errorText: state.errorText,
                        ),
                      ),
                      onChanged: state.didChange,
                    ),
                    onSaved: (name) => species.name = name,
                    validator: (value) {
                      return value == null || value == "" ? "Please enter a name" : null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: FormField(
                    builder: (state) => PlatformTextField(
                      cupertino: (context, platform) => CupertinoTextFieldData(
                        prefix: state.isValid
                            ? null
                            : Tooltip(
                                message: state.errorText ?? "Please enter a scientific name",
                                child: Icon(Icons.error),
                              ),
                        placeholder: "Scientific Name",
                      ),
                      material: (context, platform) => MaterialTextFieldData(
                        decoration: InputDecoration(labelText: "Scientific Name"),
                      ),
                      onChanged: state.didChange,
                    ),
                    onSaved: (scientificName) => species.scientificName = scientificName,
                    validator: (value) =>
                        value == null || value == "" ? "Please enter a scientific name" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformButton(
                    color: Colors.green[400],
                    child: PlatformText("Save"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        ReptiApplication.shared.database.speciesDao
                            .insertItem(species)
                            .whenComplete(() => null);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: PlatformButton(
                    color: Colors.red,
                    child: PlatformText("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

typedef Null SpeciesSelectedCallback(Species species);

class SpeciesList extends StatefulWidget {
  SpeciesSelectedCallback speciesSelectedCallback;

  SpeciesList(this.speciesSelectedCallback);

  @override
  State<SpeciesList> createState() {
    return _SpeciesListState();
  }
}

class _SpeciesListState extends State<SpeciesList> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: false,
      iosContentBottomPadding: false,
      material: (ctx, _) => MaterialScaffoldData(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAlertDialog(context),
          tooltip: "Add mixture",
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
        child: SpeciesListWidget(),
      ),
    );
  }

  Future _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return PlatformAlertDialog(
            content: Stack(
              //overflow: Overflow.visible,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: PlatformTextField(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: PlatformTextField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformButton(
                          child: PlatformText("Save"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PlatformButton(
                          child: PlatformText("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class SpeciesListWidget extends StatelessWidget {
  const SpeciesListWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReptiApplication.shared.database == null
        ? Container()
        : FutureBuilder(
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done ||
                  snap.hasData == null) {
                return Container();
              }

              return ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (BuildContext context, int index) =>
                    PlatformText(snap.data[index].name),
              );
            },
            future: ReptiApplication.shared.database.speciesDao.findAll(),
          );
  }
}

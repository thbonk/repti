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

import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

import 'package:repti/model/entities/index.dart';
import 'base_entity.dart';

@Entity(
  tableName: 'picture',
  foreignKeys: [
    ForeignKey(
      childColumns: ['individual_id'],
      parentColumns: ['id'],
      entity: Individual,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class Picture extends BaseEntity {
  @ColumnInfo(name: 'individual_id')
  final String individualId;

  @ColumnInfo(name: 'filename')
  String filename;

  @ColumnInfo(name: 'pictureData')
  Uint8List pictureData;

  Picture({
    @required Individual individual,
    @required String filename,
    @required Uint8List pictureData,
    String id,
    DateTime updateTime,
    DateTime createTime,
  })  : this.individualId = individual.id,
        this.filename = filename,
        this.pictureData = pictureData,
        super(id, updateTime, createdAt: createTime);
}

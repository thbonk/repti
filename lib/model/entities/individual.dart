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

import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

import 'package:repti/model/entities/index.dart';
import 'base_entity.dart';

enum Gender {
  male,
  female,
  unspecified,
}

@Entity(
  tableName: 'individual',
  foreignKeys: [
    ForeignKey(
      childColumns: ['species_id'],
      parentColumns: ['id'],
      entity: Species,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class Individual extends BaseEntity {
  @ColumnInfo(name: 'species_id')
  final String speciesId;

  @ColumnInfo(name: 'name')
  String name;

  @ColumnInfo(name: 'gender')
  Gender gender;

  @ColumnInfo(name: 'oviposition_date')
  DateTime ovipositionDate;

  @ColumnInfo(name: 'hatching_date')
  DateTime hatchingDate;

  @ColumnInfo(name: 'purchasing_date')
  DateTime purchasingDate;

  @ColumnInfo(name: 'date_of_sale')
  DateTime dateOfSale;

  Individual({
    @required Species species,
    @required String name,
    @required Gender gender,
    DateTime ovipositionDate,
    DateTime hatchingDate,
    DateTime purchasingDate,
    DateTime dateOfSale,
    String id,
    DateTime updateTime,
    DateTime createTime,
  })  : this.speciesId = species.id,
        this.name = name,
        this.gender = gender,
        super(id, updateTime, createdAt: createTime);
}

class GenderConverter extends TypeConverter<Gender, int> {
  @override
  Gender decode(int databaseValue) {
    return Gender.values[databaseValue];
  }

  @override
  int encode(Gender value) {
    return value.index;
  }
}

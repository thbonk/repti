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

import 'dart:async';
import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:repti/model/entities/index.dart';
import 'package:repti/model/data_access/index.dart';
import 'package:repti/model/date_time_converter.dart';

part 'repti_database.g.dart';

@TypeConverters([
  DateTimeConverter,
  GenderConverter,
])
@Database(
  version: 1,
  entities: [
    Species,
    Individual,
    Picture,
    Weight,
  ],
)
abstract class ReptiDatabase extends FloorDatabase {
  SpeciesDao get speciesDao;
  IndividualDao get individualDao;
  PictureDao get pictureDao;
  WeightDao get weightDao;
}

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

import 'package:repti/model/data_access/index.dart';
import 'package:repti/model/entities/index.dart';

@dao
abstract class SpeciesDao extends AbstractDao<Species> {
  @Query('SELECT * FROM species')
  Future<List<Species>> findAll();

  Future<int> count() async {
    return await findAll().then((list) => list.length);
  }

  @Query('SELECT * FROM species WHERE id = :id')
  Stream<Species> findSpeciesById(String id);
}
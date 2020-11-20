// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repti_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorReptiDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ReptiDatabaseBuilder databaseBuilder(String name) =>
      _$ReptiDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ReptiDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$ReptiDatabaseBuilder(null);
}

class _$ReptiDatabaseBuilder {
  _$ReptiDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$ReptiDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$ReptiDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<ReptiDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$ReptiDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ReptiDatabase extends ReptiDatabase {
  _$ReptiDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SpeciesDao _speciesDaoInstance;

  IndividualDao _individualDaoInstance;

  PictureDao _pictureDaoInstance;

  WeightDao _weightDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `species` (`name` TEXT NOT NULL, `scientific_name` TEXT NOT NULL, `id` TEXT, `created_at` INTEGER NOT NULL, `updated_at` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `individual` (`species_id` TEXT, `name` TEXT, `gender` INTEGER, `oviposition_date` INTEGER, `hatching_date` INTEGER, `purchasing_date` INTEGER, `date_of_sale` INTEGER, `id` TEXT, `created_at` INTEGER NOT NULL, `updated_at` INTEGER, FOREIGN KEY (`species_id`) REFERENCES `species` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `picture` (`individual_id` TEXT, `filename` TEXT, `pictureData` BLOB, `id` TEXT, `created_at` INTEGER NOT NULL, `updated_at` INTEGER, FOREIGN KEY (`individual_id`) REFERENCES `individual` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `weight` (`individual_id` TEXT, `weight` REAL, `id` TEXT, `created_at` INTEGER NOT NULL, `updated_at` INTEGER, FOREIGN KEY (`individual_id`) REFERENCES `individual` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SpeciesDao get speciesDao {
    return _speciesDaoInstance ??= _$SpeciesDao(database, changeListener);
  }

  @override
  IndividualDao get individualDao {
    return _individualDaoInstance ??= _$IndividualDao(database, changeListener);
  }

  @override
  PictureDao get pictureDao {
    return _pictureDaoInstance ??= _$PictureDao(database, changeListener);
  }

  @override
  WeightDao get weightDao {
    return _weightDaoInstance ??= _$WeightDao(database, changeListener);
  }
}

class _$SpeciesDao extends SpeciesDao {
  _$SpeciesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _speciesInsertionAdapter = InsertionAdapter(
            database,
            'species',
            (Species item) => <String, dynamic>{
                  'name': item.name,
                  'scientific_name': item.scientificName,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener),
        _speciesUpdateAdapter = UpdateAdapter(
            database,
            'species',
            ['id'],
            (Species item) => <String, dynamic>{
                  'name': item.name,
                  'scientific_name': item.scientificName,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener),
        _speciesDeletionAdapter = DeletionAdapter(
            database,
            'species',
            ['id'],
            (Species item) => <String, dynamic>{
                  'name': item.name,
                  'scientific_name': item.scientificName,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Species> _speciesInsertionAdapter;

  final UpdateAdapter<Species> _speciesUpdateAdapter;

  final DeletionAdapter<Species> _speciesDeletionAdapter;

  @override
  Future<List<Species>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM species',
        mapper: (Map<String, dynamic> row) => Species(
            row['name'] as String, row['scientific_name'] as String,
            id: row['id'] as String));
  }

  @override
  Stream<Species> findSpeciesById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM species WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'species',
        isView: false,
        mapper: (Map<String, dynamic> row) => Species(
            row['name'] as String, row['scientific_name'] as String,
            id: row['id'] as String));
  }

  @override
  Future<void> insertItem(Species item) async {
    await _speciesInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Species item) async {
    await _speciesUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Species item) async {
    await _speciesDeletionAdapter.delete(item);
  }
}

class _$IndividualDao extends IndividualDao {
  _$IndividualDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _individualInsertionAdapter = InsertionAdapter(
            database,
            'individual',
            (Individual item) => <String, dynamic>{
                  'species_id': item.speciesId,
                  'name': item.name,
                  'gender': _genderConverter.encode(item.gender),
                  'oviposition_date':
                      _dateTimeConverter.encode(item.ovipositionDate),
                  'hatching_date': _dateTimeConverter.encode(item.hatchingDate),
                  'purchasing_date':
                      _dateTimeConverter.encode(item.purchasingDate),
                  'date_of_sale': _dateTimeConverter.encode(item.dateOfSale),
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener),
        _individualUpdateAdapter = UpdateAdapter(
            database,
            'individual',
            ['id'],
            (Individual item) => <String, dynamic>{
                  'species_id': item.speciesId,
                  'name': item.name,
                  'gender': _genderConverter.encode(item.gender),
                  'oviposition_date':
                      _dateTimeConverter.encode(item.ovipositionDate),
                  'hatching_date': _dateTimeConverter.encode(item.hatchingDate),
                  'purchasing_date':
                      _dateTimeConverter.encode(item.purchasingDate),
                  'date_of_sale': _dateTimeConverter.encode(item.dateOfSale),
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener),
        _individualDeletionAdapter = DeletionAdapter(
            database,
            'individual',
            ['id'],
            (Individual item) => <String, dynamic>{
                  'species_id': item.speciesId,
                  'name': item.name,
                  'gender': _genderConverter.encode(item.gender),
                  'oviposition_date':
                      _dateTimeConverter.encode(item.ovipositionDate),
                  'hatching_date': _dateTimeConverter.encode(item.hatchingDate),
                  'purchasing_date':
                      _dateTimeConverter.encode(item.purchasingDate),
                  'date_of_sale': _dateTimeConverter.encode(item.dateOfSale),
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Individual> _individualInsertionAdapter;

  final UpdateAdapter<Individual> _individualUpdateAdapter;

  final DeletionAdapter<Individual> _individualDeletionAdapter;

  @override
  Future<List<Individual>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM individual',
        mapper: (Map<String, dynamic> row) => Individual(
            name: row['name'] as String,
            gender: _genderConverter.decode(row['gender'] as int),
            ovipositionDate:
                _dateTimeConverter.decode(row['oviposition_date'] as int),
            hatchingDate:
                _dateTimeConverter.decode(row['hatching_date'] as int),
            purchasingDate:
                _dateTimeConverter.decode(row['purchasing_date'] as int),
            dateOfSale: _dateTimeConverter.decode(row['date_of_sale'] as int),
            id: row['id'] as String));
  }

  @override
  Stream<Individual> findIndividualById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM individual WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'individual',
        isView: false,
        mapper: (Map<String, dynamic> row) => Individual(
            name: row['name'] as String,
            gender: _genderConverter.decode(row['gender'] as int),
            ovipositionDate:
                _dateTimeConverter.decode(row['oviposition_date'] as int),
            hatchingDate:
                _dateTimeConverter.decode(row['hatching_date'] as int),
            purchasingDate:
                _dateTimeConverter.decode(row['purchasing_date'] as int),
            dateOfSale: _dateTimeConverter.decode(row['date_of_sale'] as int),
            id: row['id'] as String));
  }

  @override
  Future<void> insertItem(Individual item) async {
    await _individualInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Individual item) async {
    await _individualUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Individual item) async {
    await _individualDeletionAdapter.delete(item);
  }
}

class _$PictureDao extends PictureDao {
  _$PictureDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _pictureInsertionAdapter = InsertionAdapter(
            database,
            'picture',
            (Picture item) => <String, dynamic>{
                  'individual_id': item.individualId,
                  'filename': item.filename,
                  'pictureData': item.pictureData,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener),
        _pictureUpdateAdapter = UpdateAdapter(
            database,
            'picture',
            ['id'],
            (Picture item) => <String, dynamic>{
                  'individual_id': item.individualId,
                  'filename': item.filename,
                  'pictureData': item.pictureData,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener),
        _pictureDeletionAdapter = DeletionAdapter(
            database,
            'picture',
            ['id'],
            (Picture item) => <String, dynamic>{
                  'individual_id': item.individualId,
                  'filename': item.filename,
                  'pictureData': item.pictureData,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Picture> _pictureInsertionAdapter;

  final UpdateAdapter<Picture> _pictureUpdateAdapter;

  final DeletionAdapter<Picture> _pictureDeletionAdapter;

  @override
  Future<List<Individual>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM picture',
        mapper: (Map<String, dynamic> row) => Individual(
            name: row['name'] as String,
            gender: _genderConverter.decode(row['gender'] as int),
            ovipositionDate:
                _dateTimeConverter.decode(row['oviposition_date'] as int),
            hatchingDate:
                _dateTimeConverter.decode(row['hatching_date'] as int),
            purchasingDate:
                _dateTimeConverter.decode(row['purchasing_date'] as int),
            dateOfSale: _dateTimeConverter.decode(row['date_of_sale'] as int),
            id: row['id'] as String));
  }

  @override
  Stream<Picture> findPictureById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM picture WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'picture',
        isView: false,
        mapper: (Map<String, dynamic> row) => Picture(
            filename: row['filename'] as String,
            pictureData: row['pictureData'] as Uint8List,
            id: row['id'] as String));
  }

  @override
  Future<void> insertItem(Picture item) async {
    await _pictureInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Picture item) async {
    await _pictureUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Picture item) async {
    await _pictureDeletionAdapter.delete(item);
  }
}

class _$WeightDao extends WeightDao {
  _$WeightDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _weightInsertionAdapter = InsertionAdapter(
            database,
            'weight',
            (Weight item) => <String, dynamic>{
                  'individual_id': item.individualId,
                  'weight': item.weight,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                }),
        _weightUpdateAdapter = UpdateAdapter(
            database,
            'weight',
            ['id'],
            (Weight item) => <String, dynamic>{
                  'individual_id': item.individualId,
                  'weight': item.weight,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                }),
        _weightDeletionAdapter = DeletionAdapter(
            database,
            'weight',
            ['id'],
            (Weight item) => <String, dynamic>{
                  'individual_id': item.individualId,
                  'weight': item.weight,
                  'id': item.id,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Weight> _weightInsertionAdapter;

  final UpdateAdapter<Weight> _weightUpdateAdapter;

  final DeletionAdapter<Weight> _weightDeletionAdapter;

  @override
  Future<List<Individual>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM weight',
        mapper: (Map<String, dynamic> row) => Individual(
            name: row['name'] as String,
            gender: _genderConverter.decode(row['gender'] as int),
            ovipositionDate:
                _dateTimeConverter.decode(row['oviposition_date'] as int),
            hatchingDate:
                _dateTimeConverter.decode(row['hatching_date'] as int),
            purchasingDate:
                _dateTimeConverter.decode(row['purchasing_date'] as int),
            dateOfSale: _dateTimeConverter.decode(row['date_of_sale'] as int),
            id: row['id'] as String));
  }

  @override
  Stream<Picture> findPWeightById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM weight WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'picture',
        isView: false,
        mapper: (Map<String, dynamic> row) => Picture(
            filename: row['filename'] as String,
            pictureData: row['pictureData'] as Uint8List,
            id: row['id'] as String));
  }

  @override
  Future<void> insertItem(Weight item) async {
    await _weightInsertionAdapter.insert(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Weight item) async {
    await _weightUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Weight item) async {
    await _weightDeletionAdapter.delete(item);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _genderConverter = GenderConverter();

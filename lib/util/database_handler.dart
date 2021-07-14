import 'package:path/path.dart';
import 'package:report1922/model/place_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'report_1922.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, code TEXT, position INTEGER)",
        );
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        await database.execute(
            "ALTER TABLE places ADD COLUMN position INTEGER default 0");
      },
      version: 2,
    );
  }

  Future<int> insert(Place place) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('places', place.toMap());
    return result;
  }

  Future<void> delete(int id) async {
    final db = await initializeDB();
    await db.delete(
      'places',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<Place?> select(int id) async {
    final db = await initializeDB();
    List<Map> queryResult =
        await db.query('places', where: "id = ?", whereArgs: [id]);
    if (queryResult.length > 0) {
      return Place(
        id: queryResult.first['id'],
        name: queryResult.first['name'],
        code: queryResult.first['code'],
        position: queryResult.first['position'],
      );
    } else {
      return null;
    }
  }

  Future<void> update(Place place) async {
    print("update(Place place) id=" + place.id.toString());
    final db = await initializeDB();
    await db.update('places', place.toMap(),
        where: "id = ?", whereArgs: [place.id]);
  }

  Future<void> updateIndex(Place place) async {
    final db = await initializeDB();
    await db.update('places', place.toMap(),
        where: "id = ?", whereArgs: [place.id]);
  }

  Future<List<Place>> getList() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult =
        await db.query('places', orderBy: 'position ASC');
    return List.generate(queryResult.length, (i) {
      return Place(
        id: queryResult[i]['id'],
        name: queryResult[i]['name'],
        code: queryResult[i]['code'],
        position: queryResult[i]['position'],
      );
    });
  }
}

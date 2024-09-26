import 'package:path/path.dart';
import 'package:posts_app/models/post.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), "my_data.db");
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''CREATE TABLE posts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          title TEXT,
           body TEXT)''');
    });
  }

  Future<void> insertPost(Post posts) async {
    final db = await database;
    db.insert("posts", posts.tojson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Post>> getAllPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("posts");
    return List.generate(maps.length, (i) {
      return Post.fromJson(maps[i]);
    });
  }

  Future<void> updatePost(Post posts) async {
    final db = await database;
    await db
        .update("posts", posts.tojson(), where: "id =?", whereArgs: [posts.id]);
  }

  Future<void> deletePost(int id) async {
    final db = await database;
    await db.delete(
      'posts',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> clearAllPosts() async {
    final db = await database;
    await db.delete('posts');
  }
}

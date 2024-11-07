import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'product.dart';
import 'package:path/path.dart';

class DbHelper{
  static Database? _db;
  Future<Database?> get db async{
    if(_db != null){
      return _db!;
    }

    _db = await initDatabase();
  }

  initDatabase() async{
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1,onCreate:_onCreate,);
    return db;
  }
  _onCreate(Database db, int version) async{
     await db.execute('CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
  }

  Future<Cart> insert(Cart cart) async{
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<int> deleteProduct(int id) async{
    var dbClient = await db;
    return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> updateProduct(Cart cart) async{
    var dbClient = await db;
    return await dbClient!.update(
        'cart',
        cart.toMap(),
        where: 'id = ?',
        whereArgs: [cart.id]
    );
  }


  Future<List<Cart>> getCartList() async{
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
    return queryResult.map((e)=> Cart.fromMap(e)).toList();
  }

}
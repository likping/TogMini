import 'package:sqflite/sqflite.dart';
import 'package:tog/Config//SearchHistory.dart';
import 'package:tog/Config//Constant.dart';
import 'package:tog/AudioComponent/Audio.dart';
class DbHelper{
  /*不知名语法。。。*/
  factory DbHelper()=>_getInstance();
  static DbHelper get instance =>_getInstance();
  static DbHelper _instance;
  DbHelper._internal();
  static DbHelper _getInstance(){
    if(_instance==null){
      _instance=new DbHelper._internal();
    }
    return _instance;
  }
  Database _db;
  Future<Database>get db async{
    var databasesPath = await getDatabasesPath();
   // String path = "Android/data/app.swust.edu.cn.tog"+'/'+Constant.dbName;
    String path=databasesPath+'/'+Constant.dbName;
//    await deleteDatabase(path);
    Database database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute('create table ${Constant.searchHistoryTable}'
              '("id" integer primary key autoincrement,'
              '"keyword" text unique,"time" integer )');
          await db.execute('create table ${Constant.playinglistTable}'
              '("id" integer primary key autoincrement,'
              '"originalId" text unique,"name" text,"link" text,"alias" text,"mvLink" text,"platform" text )');
        });
    /*
    if(null==_db) _db=await _initDb();
     return db;*/
    _db=database;
    return database;
  }

  void close() async{
    if(_db!=null ) await _db.close();
  }
  Future<SearchHistory> insertHistory(SearchHistory searchHistory)async{
    /*实验3：*/
    var __db=await db;
    try{
      searchHistory.id= await __db.insert(Constant.searchHistoryTable,searchHistory.toMap());
    }catch(e){}
    return searchHistory;

  }
  Future<SearchHistory>queryHistoryById(int id)async{
    var __db=await db;

    List<Map> maps= await __db.
    query(Constant.searchHistoryTable,where: "id=?",whereArgs: [id]);
    ;
    if(maps.length>0){
      return SearchHistory.fromMap(maps.first);
    }
    return null;
  }
  Future<List<SearchHistory>> queryHistory()async{
    var __db=await db;
    List<Map> maps=await __db.query(Constant.searchHistoryTable);
    if(maps.length>0){
      List<SearchHistory> list=new List<SearchHistory>();
      for(var map in maps){
        list.add(SearchHistory.fromMap(map));
      }
      return list;
    }
    return null;
  }
  Future<List<SearchHistory>> searchHistory(String key)async{

    var __db=await db;
    List<Map>maps=await __db.query(Constant.searchHistoryTable,
        where:"keyword like %?%",
        whereArgs: [key]
    );
    var list=List<SearchHistory>();
    maps.forEach((value){
      list.add(SearchHistory.fromMap(value));
    });
    return list;

  }
  Future<List<SearchHistory>> queryAllHistory() async{
    /**/


    var __db=await db;
    List<Map> maps=await __db.query(Constant.searchHistoryTable);
    var list=List<SearchHistory>();
    maps.forEach((value){
      list.add(SearchHistory.fromMap(value));
    });
    return list;
  }
  Future<int> deleteAllHistory() async{
    /* */
    var __db=await db;
    return await __db.delete(Constant.searchHistoryTable);
  }
  Future<int>deleteHistoryById(int id) async{
    var __db=await db;
    await __db.delete(Constant.searchHistoryTable,where: "id=?",whereArgs: [id]);
    return id;
  }
  Future<Audio> insertPlayList(Audio audio)async{
    /*实验3：*/
    var __db=await db;
    try{
      audio.dbid= await __db.insert(Constant.playinglistTable,audio.toMap());
    }catch(e){}
    return audio;
  }
  Future<Audio>queryPlayListById(int id)async{
    var __db=await db;

    List<Map> maps= await __db.
    query(Constant.playinglistTable,where: "id=?",whereArgs: [id]);
    ;
    if(maps.length>0){
      return Audio.fromMap(maps.first);
    }
    return null;
  }
  Future<List<Audio>> queryPlayList()async{
    var __db=await db;
    List<Map> maps=await __db.query(Constant.playinglistTable);
    if(maps.length>0){
      List<Audio> list=new List<Audio>();
      for(var map in maps){
        list.add(Audio.fromMap(map));
      }
      return list;
    }
    return null;
  }
  Future<List<Audio>> searchPlayList(String key)async{

    var __db=await db;
    List<Map>maps=await __db.query(Constant.playinglistTable,
        where:"name like %?%",
        whereArgs: [key]
    );
    var list=List<Audio>();
    maps.forEach((value){
      list.add(Audio.fromMap(value));
    });
    return list;

  }
  Future<List<Audio>> queryAllPlayList() async{
    /**/


    var __db=await db;
    List<Map> maps=await __db.query(Constant.playinglistTable);
    var list=List<Audio>();
    maps.forEach((value){
      list.add(Audio.fromMap(value));
    });
    return list;
  }
  Future<int> deleteAllPlayList() async{
    /* */
    var __db=await db;
    return await __db.delete(Constant.playinglistTable);
  }
  Future<int>deletePlayListById(int id) async{
    var __db=await db;
    await __db.delete(Constant.playinglistTable,where: "id=?",whereArgs: [id]);
    return id;
  }
}


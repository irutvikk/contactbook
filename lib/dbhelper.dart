import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class dbhelper {
  Future<Database> getdatabase() async {
    // Get a location using getDatabasesPath

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    print("==${path}");
    // open the database

    Database database = await openDatabase(
      path,
      version: 8,
      onCreate: (Database db, int version) async {
        await db.execute(
            "create table Contactbook (ID integer primary key autoincrement, USERNAME text, PASSWORD text, PHONE text, GENDER text, QUALIFICATION text,PLAYING boolean,READING boolean, TRAVELLING boolean,WRITING boolean, COOKING boolean) ");

        await db.execute(
            "create table Usercontact (ID integer primary key autoincrement, USERNAME text, PHONE text, GENDER text, QUALIFICATION text,PLAYING boolean,READING boolean, TRAVELLING boolean,WRITING boolean, COOKING boolean, USERID integer) ");
        },
    );
    return database;
  }

  Future<void> insertdata(
      String usernamee,
      String passwordd,
      String phoneno,
      String gender,
      String selectededucation,
      bool playing,
      bool reading,
      bool travelling,
      bool writing,
      bool cooking,
      Database db) async {
    String insertt =
        "insert into Contactbook (USERNAME,PASSWORD,PHONE,GENDER,QUALIFICATION,PLAYING,READING,TRAVELLING,WRITING,COOKING) values ('$usernamee','$passwordd','$phoneno','$gender','$selectededucation','$playing','$reading','$travelling','$writing','$cooking')";
    int a = await db.rawInsert(insertt);
  }

  Future<List<Map>> logindata(
      String usernamee, String passwordd, Database db) async {
    String select =
        "select * from Contactbook where USERNAME = '$usernamee' and PASSWORD = '$passwordd'";
    print(select);

    List<Map> ll = await db.rawQuery(select);
    return ll;
  }

  Future<bool> checkuserdata(String usernamee, Database db) async {
    String select = "select * from Contactbook where USERNAME = '$usernamee'";
    print(select);

    List<Map> ll = await db.rawQuery(select);
    if (ll.length == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map>> viewdata(Database db) async {
    var readdata = "select * from Contactbook";
    List<Map> datalist = await db.rawQuery(readdata);
    return datalist;
  }

  Future<void> deleterecord(datalist, Database db) async {
    var delete = "delete from Contactbook where ID = '$datalist'";
    List<Map> deletedata = (await db.rawDelete(delete)) as List<Map>;
    print(deletedata);
  }

  Future<void> updaterecord(usernamee, passwordd, phoneno, gender, selectededucation,
      playing, reading, travelling, writing, cooking, id, Database db) async {
    var update =
        "update Contactbook set USERNAME = '$usernamee' , PASSWORD = '$passwordd' , PHONE = '$phoneno' , GENDER = '$gender' , QUALIFICATION = '$selectededucation' , PLAYING = '$playing' , READING = '$reading' , TRAVELLING = '$travelling' , WRITING = '$writing' , COOKING = '$cooking' where ID = '$id'";
    List<Map> updatedata = (await db.rawUpdate(update)) as List<Map>;
    print("updatedata=$updatedata");
  }

  Future<void> insertcontact(String usernamee, String phoneno, String gender, String selectededucation, bool playing, bool reading, bool travelling, bool writing, bool cooking, int id, Database db) async {
    String insertcontact="insert into Usercontact (USERNAME,PHONE,GENDER,QUALIFICATION,PLAYING,READING,TRAVELLING,WRITING,COOKING,USERID) values('$usernamee','$phoneno','$gender','$selectededucation','$playing','$reading','$travelling','$writing','$cooking','$id')";
    int aa = await  db.rawInsert(insertcontact);
  }

  Future<void> updatecontact(usernamee, phoneno, gender, selectededucation,
      playing, reading, travelling, writing, cooking, id, Database db) async {
    var update =
        "update Usercontact set USERNAME = '$usernamee' , PHONE = '$phoneno' , GENDER = '$gender' , QUALIFICATION = '$selectededucation' , PLAYING = '$playing' , READING = '$reading' , TRAVELLING = '$travelling' , WRITING = '$writing' , COOKING = '$cooking' where ID = '$id'";
    List<Map> updatedata = (await db.rawUpdate(update)) as List<Map>;
    print("updatedata=$updatedata");
  }

  Future<void> deletecontact(datalist, Database db) async {
    var delete = "delete from Usercontact where ID = '$datalist'";
    List<Map> deletedata = (await db.rawDelete(delete)) as List<Map>;
    print(deletedata);
  }

  Future<List<Map>> viewcontactdata(int id,Database db) async {
    var readdata = "select * from Usercontact where USERID = '$id'";
    List<Map> datalist = await db.rawQuery(readdata);
    return datalist;
  }
}

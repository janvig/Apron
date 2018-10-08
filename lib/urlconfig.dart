import "package:flutter/material.dart";
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart' as p;
import "dart:async";

class URLConfig extends StatefulWidget {
  @override
  _URLConfigState createState() => _URLConfigState();
}

class _URLConfigState extends State<URLConfig> {
  List<Map> Data = [];
  final labelController = TextEditingController();
  final urlController = TextEditingController();

  @override
  void dispose(){
    labelController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var databasePath = await getDatabasesPath();
    String path = p.join(databasePath, "apron.db");
    print(path);

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
        "CREATE TABLE Url (id INTEGER PRIMARY KEY, label TEXT, url TEXT)"
      );
    });

    List<Map> list = await database.rawQuery("SELECT * FROM Url");

    print(list);
    setState((){
      Data = list;
    });

  }

  Future<void> removeData(var _label) async {
    var databasePath = await getDatabasesPath();
    String path = p.join(databasePath, "apron.db");

    
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
        "CREATE TABLE Url (id INTEGER PRIMARY KEY, label TEXT, url TEXT)"
      );
    });

    var count = await database.rawDelete(
      "DELETE FROM Url WHERE label = ?", [_label]
    );

    getData();
    print(count);
  }

  Future<bool> addData() async {


    String _label = labelController.text;
    String _url = urlController.text;

    var databasePath = await getDatabasesPath();
    String path = p.join(databasePath, "apron.db");

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
      // When creating the db, create the table
      
      await db.execute(
        "CREATE TABLE Url (id INTEGER PRIMARY KEY, label TEXT, url TEXT)"
      );
    });

    List<Map> list = await database.rawQuery("SELECT * FROM Url WHERE label = ? AND url = ? ", [ _label, _url]);
    print(list);
    
    if(list.length == 0){
      // if url does not exist
      await database.transaction((txn) async {

        int id = await txn.rawInsert(
          "INSERT INTO Url (label, url) VALUES ('$_label', '$_url')"
        );

        getData();
      });

      return true;
    } else {
      // Url Already exist
      return false;
    }
  
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Labels"),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: labelController,
              decoration: InputDecoration(
                labelText: "Label"
              )
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(
                      labelText: "Input URL",
                    ),
                  )
                ),
                IconButton(
                  icon: Icon(Icons.add_box),
                  iconSize: 30.0,
                  onPressed: (){
                    
                    if(addData() == false){
                    }
                  },
                )
              ]
            ),
            SizedBox(
              height: 30.0,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: Data.length,
                itemBuilder: (BuildContext context, int index){
                  return ActionChip(
                    onPressed: (){
                      var _label = Data[index]["label"];
                      removeData(_label);
                      print("Hello");
                    },
                    avatar: new CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: new Icon(Icons.remove_circle)
                    ),
                    label: new Text(Data[index]["label"])
                  );
                },
              )
            )
          ],
        ),
      )
    );
  }
}

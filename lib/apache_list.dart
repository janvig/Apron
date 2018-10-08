import "package:flutter/material.dart";
import "package:apron/drawer.dart";
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart' as p;
import "dart:async";
import "package:apron/directories.dart";


class ApacheListPage extends StatefulWidget {
  @override
  _ApacheListPageState createState() => _ApacheListPageState();
}

class _ApacheListPageState extends State<ApacheListPage> {

  Map<String, String> UrlList;
  List collegeKeys;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collegeKeys = [];
    appSetup();
  }

  Future appSetup() async {
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
      }
    );

    List<Map> list = await database.rawQuery("SELECT * FROM Url");
    print(list);
    UrlList = {
      "DA-IICT": "http://intranet.daiict.ac.in/~daiict_nt01/",
      "Programming": "http://www.dblab.ntua.gr/~gtsat/collection/",
      "CS-HUB": "http://www.csd.uwo.ca/courses/",
      "General Science": "https://cyber.rms.moe/books/03 - General Science/",
    };
    collegeKeys = [];
    for(var item in list){
      setState(() {
        
        UrlList[item['label']] = item["url"];  
      }); 
    }
    for(var college in UrlList.keys){
      setState((){
        collegeKeys.add(college);
      });
      
    }
    

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Apron"
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: appSetup
          )
        ]
      ),
      drawer: ApronDrawer(),
      body: Container(
        padding: EdgeInsets.only(
          top: 0.0,
          bottom: 0.0,
        ),
        child: ListView.builder(
          itemCount: collegeKeys.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DirPage(url: UrlList[collegeKeys[index]])
                ));
              },
              title: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          collegeKeys[index],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                          )
                        )
                      )
                    ]
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(UrlList[collegeKeys[index]])
                      )
                    ]
                  ),
                ]
              )
            );
          }
        )
      )
    );
  }
}
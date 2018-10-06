import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:async";

class DirPage extends StatefulWidget {

  String url;

  DirPage({
    String url
  }){
    this.url = url;
  } 

  @override
  DirPageState createState() => new DirPageState(url: url);
}



class DirPageState extends State<DirPage> {
  List data;
  String url;

  @override
  void initState(){
    super.initState();
    this.getData();
  }

  DirPageState({
    String url
  }){
    this.url = url;
  }

  Future<String> getData() async {
    String intranetURL = url;
    print(url);

    await Future.delayed(Duration(seconds: 2));

    var intranetResponse = await http.get(
      Uri.encodeFull(intranetURL)
    );

    RegExp exp = new RegExp(r'<tr>(.*?)alt="\[(.*?)\]"(.*?)href="(.*?)">(.*?)<\/a>(.*?)"right">(.*?)<\/td>(.*?)<\/tr>');
    Iterable<Match> matches = exp.allMatches(intranetResponse.body);
    List<Map> dirList = [];

    for(var item in matches){
      if(item.group(5) != "Parent Directory"){

        dirList.add({
          "baseUrl": url,
          "type": item.group(2),
          "href": item.group(4),
          "name": item.group(5),
          "timestamp": item.group(7)
        });

      }
    }

    setState((){
      data = dirList;
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Apron"),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Row(
                children: <Widget>[
                  new Icon(Icons.edit),
                  new Text(" Add/Remove Url")
                ]
              ),
              onTap: (){}
            ),
            new ListTile(
              title: new Row(
                children: <Widget>[
                  new Icon(Icons.info_outline),
                  new Text(" About")
                ]
              ),
              onTap: (){}
            )
          ]
        )
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index){
            var item = data[index];
            return Container(
              child: ListTile(
                
                title: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        Icon((item["type"] == "DIR") ? Icons.folder_open : Icons.insert_drive_file),
                        Text(" " + item["name"], style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0
                        ))
                      ]
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(item["timestamp"], style: TextStyle(
                          color: Colors.black54,
                          fontSize: 11.0
                        ))
                      ],
                    )
                  ]
                ),
                onTap: (){
                  print(data[index]["name"]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DirPage(url: data[index]["baseUrl"] + data[index]["name"])
                  ));
                }
              )
            );
          }
        ),
        onRefresh: getData,
      )
    );
  }
}
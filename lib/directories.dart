import "package:flutter/material.dart";
import "package:apron/drawer.dart";
import 'package:url_launcher/url_launcher.dart';
import "package:http/http.dart" as http;
import "dart:async";
import 'package:apron/apron_widgets.dart';

class DirPage extends StatefulWidget {

  final String url;

  DirPage({
    this.url
  });

  @override
  DirPageState createState() => new DirPageState(url: url);
}



class DirPageState extends State<DirPage> {

  List data;
  String url;
  Map<String,dynamic> prop = {
    'loading' : 0,
    'error' : ''
  };

  @override
  void initState(){
    super.initState();
    this.getData();
  }

  DirPageState({
    String url,
    String error
  }){
    this.url = url;
  }

  Future<String> getData() async {
    String intranetURL = url;
    print(url);

    setState(() {
      prop['loading'] = 0;
    });

    try {

      if(intranetURL[intranetURL.length - 1] != '/'){
        if(await canLaunch(intranetURL)){
          await launch(intranetURL);
          if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        } else {
          setState((){
            prop['error'] = "Error Opening this file.";
            prop['loading'] = -1;
          });
        }
      }

      var intranetResponse = await http.get(
        Uri.encodeFull(intranetURL)
      );

      // Setup
      bool apache = false;
      RegExp exp;
      Iterable<Match> matches;
      List<Map> dirList;

      exp = new RegExp(r'<tr>(.*?)alt="\[(.*?)\]"(.*?)href="(.*?)">(.*?)<\/a>(.*?)"right">(.*?)<\/td>(.*?)<\/tr>');

      print(intranetResponse.body);
      matches = exp.allMatches(intranetResponse.body);
      dirList = [];

      for(var item in matches){
        if(item.group(5) != "Parent Directory"){
          apache = true;
          dirList.add({
            "baseUrl": url,
            "type": item.group(2),
            "href": item.group(4),
            "name": item.group(5),
            "timestamp": item.group(7)
          });

        }
      }

      if(!apache){ 
        exp = new RegExp(r'<a href="(.*?)">(.*?)</a>\s+(.*?)\s+');

        matches = exp.allMatches(intranetResponse.body);
        dirList = [];


        for(var item in matches){
          if(item.group(2) != "../"){
            try {
              print(item.group(1) + " " + item.group(3));
            } catch(e) {
              print("Error 1");
            }
            
          }
        }

        for(var item in matches){
          if(item.group(1) != "../"){
            try {
              dirList.add({
                "baseUrl": url,
                "href": item.group(1),
                "name": item.group(2),
                "type": item.group(2)[item.group(2).length - 1] == '/' ? "DIR" : "",
                "timestamp": item.group(3)
              });
            } catch(e) {
              print("Error 2");
            }
          }
          
        }
      }

      setState((){
        data = dirList;
        prop['error'] = dirList.length == 0 ? "Empty Directory" : "";
        prop['loading'] = dirList.length == 0 ? -1 : 1;
      });
    } catch(e) {
      setState((){
        prop['error'] = "Unable to get data: Check if your Internet is working.";
        prop['loading'] = -1;
      });
    }
    return "Success";
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Apron"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: getData,
          )
        ]
      ),
      drawer: ApronDrawer(),
      body: RefreshIndicator(
        child: prop['loading'] == 1 ? ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index){
            var item = data[index];
            return Container(
              child: ListTile(
                title: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        Icon((item["type"] == "DIR") ? Icons.folder : Icons.insert_drive_file),
                        Flexible(
                          child: Text(
                            " " + item["name"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0
                            )
                          )
                        )
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
                    MaterialPageRoute(builder: (context) => DirPage(url: data[index]["baseUrl"] + Uri.decodeFull(data[index]["href"]))
                  ));
                }
              )
            );
          }
        ) : Screen(state: prop,),
        onRefresh: getData,
      )
    );
  }
}

class Screen extends StatelessWidget {

  final dynamic state;

  Screen({this.state});

  @override
  Widget build(BuildContext context) {
    if(state["loading"] == 0){
      return Center(
        child: LoadingWidget(),
      );
    }
    else {
      return Center(
        child: InternetLostWidget(state["error"])
      );
    }
  }
}


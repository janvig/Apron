import "package:flutter/material.dart";
import "package:apron/urlconfig.dart";

class ApronDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Apron',
                style: TextStyle(
                  fontSize: 30.0
                )
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
            ),
            new ListTile(
              title: new Row(
                children: <Widget>[
                  new Icon(Icons.edit),
                  new Text(" Add/Remove Url")
                ]
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => URLConfig()
                ));
              }
            ),
            new ListTile(
              title: new Row(
                children: <Widget> [
                  new Icon(Icons.arrow_downward),
                  new Text(" Saved Files")
                ]

              ),
              onTap: (){
                
              }
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
      );
  }
}
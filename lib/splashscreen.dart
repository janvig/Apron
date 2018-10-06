import "package:flutter/material.dart";
import "dart:async";
import "package:apron/directories.dart";


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 0), () => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => DirPage(url: "http://intranet.daiict.ac.in/~daiict_nt01/")
      ),
      (Route<dynamic> route) => false
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Apron", style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold, 
                        color: Colors.amber,
                      )),
                      Text("Powered By Dash.", style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.amber
                      ))
                    ]
                  )
                )
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0)
                    )
                  ]
                )
              )

            ]
          )
        ]
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class LoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget> [
          Container(
            child: FlareActor(
              "assets/minion.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Stand",
              shouldClip: true,
            ),
            width: 180.0,
            height: 180.0,
          ),
          Container(
            padding: EdgeInsets.only(left: 60, top: 130.0),
            child: Text("Loading . . .", style: TextStyle(color: Colors.black54),),
          ),
        ]
    );
  }
}

class InternetLostWidget extends StatelessWidget {

  final String err;
  InternetLostWidget(this.err);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget> [
        Container(
          child: FlareActor(
            "assets/minion.flr",
            animation: 'Circular',
            alignment: Alignment.center,
            fit: BoxFit.contain,
            shouldClip: true,
          ),
          width: 180.0,
          height: 180.0,
        ),
        Container(
          padding: EdgeInsets.only(left: 50, top: 130.0),
          child: Text(
            this.err,
            style: TextStyle(
              color: Colors.black54
            ),
          ),
        ),
      ]
    );
  }
}


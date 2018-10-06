import "package:flutter/material.dart";
import "package:apron/splashscreen.dart";

void main(){
  runApp( 
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Apron",
      theme: new ThemeData(
        primarySwatch: Colors.amber
      ),
      home: SplashScreen(),
    )
  );
}


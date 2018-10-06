import "package:flutter/material.dart";
import "package:apron/apache_list.dart";

void main(){
  runApp( 
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Apron",
      theme: new ThemeData(
        primarySwatch: Colors.amber
      ),
      home: ApacheListPage(),
    )
  );
}


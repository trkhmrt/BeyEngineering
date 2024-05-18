import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DesignPage extends StatefulWidget{
  @override
  _GuncellemeState createState()=>_GuncellemeState();
}

class _GuncellemeState extends State<DesignPage> {


  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Guncelleme Ekranı'),
      ),
      body: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Draggable<String>(
                // Data is the value this Draggable stores.
                data: 'red',
                child: Container(
                  height: 50,
                  width: 50,
                  child: Column(
                    children: [
                      Text('Text 1'),
                      Text('Text 2'),
                      Text('Text 3'),
                    ],
                  ),
                ),
                feedback: Container(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text("SÜRÜKLENİYOR"),
                  ),
                ),
                childWhenDragging: Container(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                    child:Text("HELLO"),
                  ),
                ),

              ),
  ]))
    );
  }
}
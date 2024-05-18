import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Guncelleme.dart';
import 'Projeler.dart';

class Menu extends StatefulWidget{
  @override
  _MenuState createState()=>_MenuState();
}

class _MenuState extends State<Menu> {

  String username = '';
  String firstname = '';
  String lastname = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    _loadToken();

  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
       username =    prefs.getString('username') ?? "";
       firstname =    prefs.getString('firstname') ?? "";
       lastname =    prefs.getString('lastname') ?? "";
       role =    prefs.getString('role') ?? "";
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Menü'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Kullanıcı adı: ${username}"),
              SizedBox(height: 16), // add some space between the Text widgets
              Text("İsim: ${firstname} ${lastname}"),
              SizedBox(height: 16), // add some space between the Text widgets
              Text("Kullanıcı Rolü: ${role}"),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GuncellemeSayfasi()),
                    )
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange), // Buton arka plan rengi
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Buton metin rengi
                  ),
                  child:  Text('Bilgi Güncelle')),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DesignPage()),
                    )
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Buton arka plan rengi
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Buton metin rengi
                  ),
                  child:  Text('Proje Listele')),
              SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}
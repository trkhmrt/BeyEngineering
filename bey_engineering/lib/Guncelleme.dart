import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GuncellemeSayfasi extends StatefulWidget{
  @override
  _GuncellemeState createState()=>_GuncellemeState();
}

class _GuncellemeState extends State<GuncellemeSayfasi> {

  String username = '';
  String accesToken = '';
  String firstname = '';
  String lastname = '';
  String role = '';

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _setLocalStorage().then((_) {
      _loadUserInfo();
    });;


  }
  Future<void> _setLocalStorage() async{

    final localStorage = await SharedPreferences.getInstance();
    setState(() {
      accesToken =  localStorage.getString("accessToken") ?? "";
      username =  localStorage.getString("username") ?? "";
    });

  }

  Future<void> _loadUserInfo() async {

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/getuser'),
        headers:{
          'Content-Type': 'application/json',
          "Authorization":'Bearer ${accesToken}'
        },
        body: jsonEncode(<String, String>{
          'username': username,
        }),
      );
      print(username);
      print(accesToken);
      if (response.statusCode == 200) {
        // Başarılı yanıt durumunda
        print('Bilgiler Başarıyla Çekildi');
        print('Sunucudan gelen yanıt: ${response.body}');

        Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          firstname = data['firstname'];
          lastname = data['lastname'];
        });

      } else {
        // Hatalı yanıt durumunda
        print('Giriş başarısız. Hata kodu: ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
      }
    } catch (e) {
      // Hata durumunda
      print('İstek yapılırken hata oluştu: $e');
    }




  }
  Future<void> _updateUser() async{
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/update'),
        headers:{
          'Content-Type': 'application/json',
          "Authorization":'Bearer ${accesToken}'
        },
        body: jsonEncode(<String, String>{
          'username' : username,
          'firstName': firstnameController.text,
          'lastName': lastnameController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Başarılı yanıt durumunda
        print('Bilgiler Başarıyla Güncellendi');
        print('Sunucudan gelen yanıt: ${response.body}');
        final localStorage = await SharedPreferences.getInstance();

        await localStorage.remove('firstname');
        await localStorage.remove('lastname');

        await localStorage.setString('firstname',firstnameController.text);
        await localStorage.setString('lastname',lastnameController.text);
      } else {
        // Hatalı yanıt durumunda
        print('Giriş başarısız. Hata kodu: ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
      }
    } catch (e) {
      // Hata durumunda
      print('İstek yapılırken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Guncelleme Ekranı'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 250,
                  child:TextField (
                    controller: firstnameController,
                    decoration: InputDecoration(labelText:'Ad:${firstname}',hintText:'yeni isim giriniz...'),
                    obscureText: false,
                  )
              ),
              SizedBox(height: 16),
              SizedBox(
                  width: 250,
                child:TextField (
                controller: lastnameController,
                decoration: InputDecoration(labelText:  'Soyad:${lastname}',hintText: 'yeni soyad giriniz...' ),
                obscureText: false,
              )
              ), // add some space between the Text widgets
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _updateUser,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange), // Buton arka plan rengi
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Buton metin rengi
                  ),
                  child:  Text('Güncelle')),
              SizedBox(height: 16),



            ],
          ),
        ),
      ),
    );
  }
}
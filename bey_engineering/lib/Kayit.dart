import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class Kayit extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<void> SendRegisterData() async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String username = usernameController.text;
    String password = passwordController.text;


    // String apiUrl = 'http://localhost:8080/login'; // API URL'si

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/register'),
        headers:{
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work


          "Access-Control-Allow-Methods": "POST, OPTIONS",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'firstname':name,
          'lastname':lastname,
          'username': username,
          'password': password,
          'role':"ADMIN"
        }),
      );

      if (response.statusCode == 200) {
        // Başarılı yanıt durumunda
        print('Başarıyla kayıt yapıldı.');
        print('Sunucudan gelen yanıt: ${response.body}');
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
        title: Text('Kayıt Ekranı'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'İsim'),
            ),
            TextField(
              controller: lastnameController,
              decoration: InputDecoration(labelText: 'Soyisim'),
              obscureText: true,
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı adı'),
              obscureText: true,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: SendRegisterData,
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
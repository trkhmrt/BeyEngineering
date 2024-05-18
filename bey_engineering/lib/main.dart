import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Kayit.dart';
import 'Menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Example',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {



  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

   // String apiUrl = 'http://localhost:8080/login'; // API URL'si

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/login'),
        headers:{
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Başarılı yanıt durumunda
        print('Başarıyla giriş yapıldı.');
        print('Sunucudan gelen yanıt: ${response.body}');
        //------------------------------------TOKEN ALINDI--------------
        Map<String, dynamic> data = jsonDecode(response.body);
        String accessToken = data['access_token'];
       //-------TOKENIN KULLANICI BİLGİLERİ İÇEREN İKİNCİ KISMI DECODE EDİLİYOR------



        //-----PAYLOAD İÇİNDEKİ JSON NESNESİ ÇÖZÜMLENİR------
        // JWT'yi çözümle
        Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
        print("Çözülen TOken:${decodedToken}");
        // Kullanıcı adını al
        String tokenUsername = decodedToken['sub'];
        String firstname = decodedToken['firstname'];
        String lastname = decodedToken['lastname'];
        String role = decodedToken['role'];


        //TOKENI LOCALSTORAGE E EKLEME
        final localStorage = await SharedPreferences.getInstance();
        await localStorage.setString('accessToken', accessToken);
        await localStorage.setString('username', tokenUsername);
        await localStorage.setString('firstname', firstname);
        await localStorage.setString('lastname', lastname);
        await localStorage.setString('role', role);




        //-------MENU SAYFASINA YÖNLENDİRME YAP-----
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
        );
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
        title: Text('Giriş Ekranı'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child:  TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
              ),
            ),
           SizedBox(
               width: 250,
             child: TextField(
               controller: passwordController,
               decoration: InputDecoration(labelText: 'Şifre'),
               obscureText: true,
             ),
           ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => login(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Buton arka plan rengi
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Buton metin rengi
                  ),
                  child: Text('Giriş Yap'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Kayit()),
                  )
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Buton arka plan rengi
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Buton metin rengi
                  ),
                  child: Text('Kayıt Ol'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

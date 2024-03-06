import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vtweb/services/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Visage Track', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Centraliza verticalmente na tela
                children: [
                  Container(
                    width: 500,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Projeto Visage Track',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Venha conosco embarcar nesta missão de otimização de potencial de seus alunos, ou funcionarios!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Espaço entre o container e o botão de login
                  ElevatedButton(
                     onPressed: () async {
                      User? user = await signInWithGoogle();
                      if (user != null) {
                        print("Login bem-sucedido: ${user.displayName}");
                        // Navegue para a próxima tela após o login bem-sucedido
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => NextScreen()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue, backgroundColor: Colors.white, // Cor do texto do botão
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text('Login com Google'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
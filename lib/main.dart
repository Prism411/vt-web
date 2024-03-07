import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vtweb/screens/analysis.dart';
import 'package:vtweb/services/auth/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// Adicionando GlobalKey para o NavigatorState
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Usando a GlobalKey aqui
      home: Scaffold(
        appBar: AppBar(
          title: Text('Visage Track', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            ImageFader(), // Usando ImageFader para alternar imagens com fade
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          'Venha conosco embarcar nesta missão de otimização de potencial de seus alunos, ou funcionários!',
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      User? user = await signInWithGoogle();
                      if (user != null) {
                        print("Login bem-sucedido: ${user.displayName}");
                        // Navegação usando a GlobalKey
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => AnalysisScreen(currentUser: user),
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue, backgroundColor: Colors.white,
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

class ImageFader extends StatefulWidget {
  const ImageFader({Key? key}) : super(key: key);

  @override
  _ImageFaderState createState() => _ImageFaderState();
}

class _ImageFaderState extends State<ImageFader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;
  final List<String> _images = [
    'assets/images/background (1).png',
    'assets/images/background (2).png',
    'assets/images/background (3).png',
    'assets/images/background (4).png',
    'assets/images/background (5).png',
    'assets/images/background (6).png',
    'assets/images/background (7).png',
    'assets/images/background (8).png',
    'assets/images/background (9).png',
    'assets/images/background (10).png',
    // Adicione mais imagens conforme necessário
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _images.length;
        });
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            _images[_currentIndex],
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: FadeTransition(
            opacity: _controller,
            child: Container(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

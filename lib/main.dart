import 'dart:async';

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

class _ImageFaderState extends State<ImageFader> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;
  Timer? _timer;
  int _currentIndex = 0;
  bool _isAnimating = false; // Adicionado para controlar o estado da animação

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
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Duração total para o fade in e fade out
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn), // Primeira metade da animação
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeOut), // Segunda metade da animação
      ),
    );

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _startTimer();
      }
    });

    _startAnimation();
  }

  void _startTimer() {
    if (_isAnimating) return; // Evita reiniciar a animação se já estiver em andamento
    _isAnimating = true;

    _timer = Timer(Duration(seconds: 1), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
      _startAnimation();
    });
  }

  void _startAnimation() {
    _controller.forward(from: 0.0).then((_) {
      _isAnimating = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextIndex = (_currentIndex + 1) % _images.length;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          _images[_currentIndex],
          fit: BoxFit.cover,
        ),
        FadeTransition(
          opacity: _fadeIn, // Fade in da próxima imagem
          child: Image.asset(
            _images[nextIndex],
            fit: BoxFit.cover,
          ),
        ),
        FadeTransition(
          opacity: _fadeOut, // Fade out da imagem atual
          child: Image.asset(
            _images[_currentIndex],
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

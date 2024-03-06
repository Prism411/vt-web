import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AnalysisScreen extends StatefulWidget {
  final User currentUser;

  AnalysisScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  // Substitua 'graph_1' pelo caminho da sua imagem que será atualizada constantemente
  final String graphImage = 'assets/graph_1.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Olá, ${widget.currentUser.displayName}',
          style: TextStyle(
              fontSize: 24,
              color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Implemente a abertura da janela de notificações aqui
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: 10, // Supondo 10 linhas de dados
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Nome $index'), // Substitua pelos dados reais
                    subtitle: Text('Faltas: ${index * 2}, Humor: Bom'), // Substitua pelos dados reais
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(graphImage, fit: BoxFit.cover),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Atualize a imagem ou implemente outra ação
                    },
                    child: Text('Atualizar Gráfico'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

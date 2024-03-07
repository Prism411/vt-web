import 'dart:async'; // Importe a biblioteca dart:async
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vtweb/services/call/model.dart'; // Substitua pelo caminho correto

class AnalysisScreen extends StatefulWidget {
  final User currentUser;

  AnalysisScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<UserData> usersData = [];
  int currentBlock = 1;
  Timer? _timer; // Adiciona uma variável para o Timer

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Certifique-se de cancelar o timer quando o widget for desmontado
    super.dispose();
  }

  void _startAutoFetch() {
    // Cancela qualquer timer existente
    _timer?.cancel();

    // Cria um novo timer que chama _fetchBlockData a cada 10 Ssegundos
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _fetchBlockData(currentBlock++);
    });
  }

  Future<void> _fetchBlockData(int bloco) async {
    try {
      final users = await fetchUsersDataBlock(bloco);
      setState(() {
        usersData = users;
      });
    } catch (e) {
      print('Erro ao buscar os dados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Análise de Usuários - Dia: $currentBlock'),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(usersData[index].name),
                  subtitle: Text('Humor: ${usersData[index].humor}, Faltas: ${usersData[index].faltas}'),
                );
              },
            ),
          ),
          if (usersData.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
             child: Image.network(
                'http://localhost:8080' + usersData.first.filepath, // Concatena a base URL com o filepath
                width: 500,
                height: 500,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startAutoFetch, // Atualiza para chamar _startAutoFetch
        tooltip: 'Começar', 
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

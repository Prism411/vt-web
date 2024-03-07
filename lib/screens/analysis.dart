import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:vtweb/services/call/model.dart'; // Substitua pela localização correta de onde sua classe UserData está definida.

class AnalysisScreen extends StatefulWidget {
  final User currentUser;

  AnalysisScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<UserData> usersData = []; // Lista para armazenar os dados dos usuários

  @override
  void initState() {
    super.initState();
    // Chamada inicial para buscar os dados dos usuários
    fetchAllUserData();
  }

  // Função para buscar todos os UserData.
  Future<void> fetchAllUserData() async {
    // Limpa a lista existente para garantir que os dados sejam realmente atualizados
    usersData.clear();
    
    for (int i = 0; i < 10; i++) {
      try {
        final response = await http.get(Uri.parse('http://localhost:8080/sendUserData/$i'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          final userData = UserData.fromJson(jsonResponse);
          setState(() {
            usersData.add(userData);
          });
        }
      } catch (e) {
        print('Erro ao buscar os dados: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${widget.currentUser.displayName}'),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(usersData[index].name),
                  subtitle: Text('Humor: ${usersData[index].humor}\nFaltas: ${usersData[index].faltas}'),
                );
              },
            ),
          ),
          if (usersData.isNotEmpty) // Verifica se a lista não está vazia antes de tentar acessar
            Image.network(usersData[0].filepath, width: 100, height: 100),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchAllUserData();
        },
        tooltip: 'Recarregar Dados',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
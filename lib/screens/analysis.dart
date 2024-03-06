import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vtweb/services/call/model.dart'; // Certifique-se de importar o call.dart corretamente

class AnalysisScreen extends StatefulWidget {
  final User currentUser;

  AnalysisScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<UserData> _usersData = []; // Lista para armazenar os dados dos usuários

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Olá, ${widget.currentUser.displayName}',
          style: TextStyle(fontSize: 24, color: Colors.white),
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
                itemCount: _usersData.length, // Usa o tamanho da lista de dados dos usuários
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_usersData[index].name), // Usa o nome do usuário
                    subtitle: Text('Faltas: ${_usersData[index].faltas}, Humor: ${_usersData[index].humor}'), // Usa faltas e humor
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
                  if (_usersData.isNotEmpty) // Verifica se _usersData não está vazio
                    Expanded(
                      child: Image.asset(_usersData.first.graphImage, fit: BoxFit.cover),
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      var usersData = await fetchUserData();
                      setState(() {
                        _usersData = usersData;
                        // Não é necessário atualizar _graphImage aqui, pois cada UserData agora contém sua própria imagem
                      });
                    },
                    child: Text('Começar Simulação'),
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

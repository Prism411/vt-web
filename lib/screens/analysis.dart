import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:vtweb/services/call/model.dart'; // Certifique-se de que este caminho está correto

class AnalysisScreen extends StatefulWidget {
  final User currentUser;

  AnalysisScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<UserData> _usersData = [];

  @override
  void initState() {
    super.initState();
    fetchUserDataFromModel();
  }

  Future<void> fetchUserDataFromModel() async {
    try {
      final usersData = await fetchUserData(); // Supondo que esta função está definida em 'model.dart'
      setState(() {
        _usersData = usersData;
      });
    } catch (e) {
      print('Erro ao buscar os dados: $e');
    }
  }

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
                itemCount: _usersData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_usersData[index].name),
                    subtitle: Text('Humor: ${_usersData[index].humor}'),
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
                    // Ajuste a exibição da imagem conforme necessário
                    Expanded(
                      child: Image.network('http://189.31.9.230:8080/packages/graph/regressao_20.png'),
                    ),
                  ElevatedButton(
                    onPressed: fetchUserDataFromModel,
                    child: Text('Recarregar Dados'),
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

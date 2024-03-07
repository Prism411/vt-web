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

  @override
  void initState() {
    super.initState();
    _fetchBlockData(currentBlock);
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
        title: Text('Análise de Usuários'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          if (usersData.isNotEmpty) // Verifica se a lista não está vazia
            Image.network(
              usersData.first.filepath,
              width: 100,
              height: 100,
              alignment: Alignment.centerLeft,
            ),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentBlock++;
          });
          _fetchBlockData(currentBlock);
        },
        tooltip: 'Carregar mais',
        child: Icon(Icons.add),
      ),
    );
  }
}

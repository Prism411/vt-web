import 'dart:async'; // Importe a biblioteca dart:async
import 'dart:math' show Random; // Para gerar números aleatórios
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
  List<int> days = [1];
  int selectedDay = 1;
  Timer? _timerDays;
  Timer? _timerFetch;
  Timer? _timerMessageUpdate;
  String randomMessage = "Carregando..."; // Mensagem inicial

  final List<String> messages = [
    "está se sentindo feliz hoje!",
    "está se sentindo triste ultimamente.",
    "parece estar tendo um ótimo dia!",
    "poderia estar se sentindo melhor.",
    "está em um ótimo humor hoje!",
    "Demonstra tristeza recorrente.",
    "Está se sentido muito bem!",
    "Está se sentindo mal.",
    "Está triste novamente, está tudo bem?",
    "Está altamente produtivo!",
  ];

  @override
  void initState() {
    super.initState();
    _startAutoAddDays();
    _startAutoFetch();
    _timerMessageUpdate = Timer.periodic(Duration(days: 5), (Timer t) => _updateRandomMessage());
  }

  @override
  void dispose() {
    _timerDays?.cancel();
    _timerFetch?.cancel();
    _timerMessageUpdate?.cancel();
    super.dispose();
  }

  void _startAutoAddDays() {
    _timerDays = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        int nextDay = days.last + 1;
        days.add(nextDay);
        if (selectedDay == days[days.length - 2]) {
          selectedDay = nextDay;
          _fetchBlockData(selectedDay);
        }
      });
    });
  }

  void _startAutoFetch() {
    _timerFetch?.cancel();
  }

  Future<void> _fetchBlockData(int block) async {
    try {
      final users = await fetchUsersDataBlock(block);
      setState(() {
        usersData = users;
      });
      _updateRandomMessage(); // Atualiza a mensagem com os dados recém carregados
    } catch (e) {
      print('Erro ao buscar os dados: $e');
    }
  }

  void _updateRandomMessage() {
    if (usersData.isNotEmpty) {
      final randomUser = usersData[Random().nextInt(usersData.length)];
      final message = messages[Random().nextInt(messages.length)];
      setState(() {
        randomMessage = "${randomUser.name} $message";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Análise de Usuários - Dia: $selectedDay'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
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
                  ],
                ),
              ),
              if (usersData.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.network(
                      'http://localhost:8080' + usersData.first.filepath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
          Center(
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    randomMessage,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: DropdownButton<int>(
        value: selectedDay,
        onChanged: (newValue) {
          setState(() {
            selectedDay = newValue!;
            _fetchBlockData(selectedDay);
          });
        },
        items: days.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('Dia $value'),
          );
        }).toList(),
      ),
    );
  }
}

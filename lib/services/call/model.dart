import 'dart:async';
import 'package:flutter/material.dart';

// Modelo de dados para o usuário
class UserData {
  final String name;
  final int faltas;
  final String humor;

  UserData({required this.name, required this.faltas, required this.humor});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      faltas: json['faltas'],
      humor: json['humor'],
    );
  }
}

// Simula a chamada de API para buscar os dados dos usuários
Future<List<UserData>> fetchUserData() async {
  // Simulando atraso da chamada de rede
  await Future.delayed(Duration(seconds: 2));

  // Simula os dados que seriam recebidos da sua API
  List<Map<String, dynamic>> jsonData = [
    {"name": "Usuario 1", "faltas": 2, "humor": "Bom"},
    {"name": "Usuario 2", "faltas": 0, "humor": "Ótimo"},
    // Adicione mais usuários conforme necessário
  ];

  return jsonData.map((user) => UserData.fromJson(user)).toList();
}

// Função para a chamada real da API será adicionada aqui posteriormente
/*
Future<List<UserData>> fetchUserData() async {
  final response = await http.get(Uri.parse('SUA_URL_DA_API'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => UserData.fromJson(item)).toList();
  } else {
    throw Exception('Falha ao carregar dados');
  }
}
*/

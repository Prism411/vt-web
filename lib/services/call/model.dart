import 'dart:convert';
import 'package:http/http.dart' as http;

class UserData {
  final String name;
  final String humor;
  final int faltas;
  final String filepath; // Adicionado o novo campo

  UserData({
    required this.name,
    required this.humor,
    required this.faltas,
    required this.filepath, // Inicializar no construtor
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      humor: json['humor'],
      faltas: json['faltas'],
      filepath: json['filepath'], // Extrair do JSON
    );
  }
}

Future<UserData> fetchUserData(int index) async {
  final response = await http.get(Uri.parse('http://localhost:8080/sendUserData/$index'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return UserData.fromJson(jsonResponse);
  } else {
    throw Exception('Falha ao carregar dados do servidor');
  }
}


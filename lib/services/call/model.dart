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

Future<List<UserData>> fetchUsersDataBlock(int bloco) async {
  final response = await http.get(Uri.parse('http://localhost:8080/usuarios?bloco=$bloco'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => UserData.fromJson(data)).toList();
  } else {
    throw Exception('Falha ao carregar dados do bloco $bloco');
  }
}



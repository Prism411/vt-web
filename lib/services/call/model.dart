import 'dart:convert';
import 'package:http/http.dart' as http;

class UserData {
  final String name;
  final int faltas;
  final String humor;
  final String graphImage; // Nova propriedade

  UserData({
    required this.name,
    required this.faltas,
    required this.humor,
    required this.graphImage, // Inicialização da nova propriedade
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'], 
      faltas: json['faltas'],
      humor: json['humor'],
      graphImage: json['graphImage'], // Atribuição da nova propriedade
    );
  }
}

  Future<List<UserData>> fetchUserData() async {
  final uri = Uri.parse('http://localhost:8080/fetchUserData');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => UserData.fromJson(item)).toList();
  } else {
    throw Exception('Falha ao carregar dados');
  }
}


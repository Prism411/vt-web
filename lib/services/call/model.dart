import 'dart:convert';
import 'package:http/http.dart' as http;

class UserData {
  final String name;
  final String humor;

  UserData({required this.name, required this.humor});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['Name'], // Certifique-se de que a chave corresponde ao seu JSON
      humor: json['Humor'], // Certifique-se de que a chave corresponde ao seu JSON
    );
  }
}

Future<List<UserData>> fetchUserData() async {
  final uri = Uri.parse('http://localhost:8080/updateHumor'); // URL atualizada
  final response = await http.get(uri, headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((dynamic item) => UserData.fromJson(item)).toList();
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

void main() async {
  try {
    List<UserData> users = await fetchUserData();
    for (var user in users) {
      print('Nome: ${user.name}');
      print('Humor: ${user.humor}');
      // O link da imagem não será impresso, pois não está sendo processado na requisição atual
    }
  } catch (e) {
    print('Erro ao buscar os dados: $e');
  }
}

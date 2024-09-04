import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({required this.id, required this.name, required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }

}

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar los usuarios');
  }
}

List<User> userUsername(List<User> users) {
  return users.where((user) => user.username.length > 6).toList();
}

int usersWithBiz(List<User> users) {
  return users.where((user) => user.email.endsWith('@biz')).length;
}

void main() async {
  try {
    List<User> users = await fetchUsers();

    List<User> usuariosFiltrados = userUsername(users);
    print('Usuarios con username de mas de 6 caracteres:');
    for(var user in usuariosFiltrados) {
      print('Nombre de Usuario: ${user.username} | Nombre: (${user.name})');
    }

    int contador = usersWithBiz(users);
    print('\nCantidad de usuarios con email del dominio "Biz": $contador');
  } catch (e) {
    print('Error: $e');
  }
}

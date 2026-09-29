import 'package:favatonka/usuario.dart';

/// Login "mockado": usuários fictícios e fixos no código (hardcoded).
class Autenticador {
  static const List<Map<String, String>> _usuarios = [
    {'nome': 'Ana Tonka', 'email': 'fava@tonka.com', 'senha': '123456'},
    {'nome': 'Carlos Âmbar', 'email': 'carlos@tonka.com', 'senha': '123456'},
  ];

  static Future<Usuario?> login(String email, String senha) async {
    await Future.delayed(const Duration(milliseconds: 400));

    for (final u in _usuarios) {
      if (u['email'] == email.trim().toLowerCase() && u['senha'] == senha) {
        return Usuario(u['nome']!, u['email']!);
      }
    }
    return null;
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 150));
  }
}

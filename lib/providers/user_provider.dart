import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';

  String get username => _username;

  void login(String username) {
    _username = username;
    notifyListeners();
    print('Novo usuário definido: $username'); // Teste
  }

  void logout() {
    _username = '';
    notifyListeners();
  }
}

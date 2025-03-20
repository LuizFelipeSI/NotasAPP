import 'package:flutter/material.dart';

class DisciplinaProvider with ChangeNotifier {
  // Armazenando as disciplinas (exemplo simples, poderia vir de um banco de dados)
  List<Map<String, dynamic>> _disciplinas = [
    {
      'nome': 'Matemática',
      'nota': 8.5,
      'presenca': '90%',
      'descricao': 'Álgebra, geometria e cálculos.',
      'provas': [],
      'trabalhos': [],
      'anotacoes': '',
    },
    {
      'nome': 'Português',
      'nota': 7.8,
      'presenca': '85%',
      'descricao': 'Gramática, literatura e redação.',
      'provas': ['20/03/2025', '15/04/2025'],
      'trabalhos': ['30/03/2025'],
      'anotacoes': '',
    },
    // Adicione mais disciplinas conforme necessário
  ];

  List<Map<String, dynamic>> get disciplinas => _disciplinas;

  // Função para atualizar as anotações de uma disciplina
  void updateAnotacao(String nome, String anotacao) {
    final index = _disciplinas.indexWhere(
      (disciplina) => disciplina['nome'] == nome,
    );
    if (index != -1) {
      _disciplinas[index]['anotacoes'] = anotacao;
      notifyListeners(); // Notificar os ouvintes de que a anotação foi alterada
    }
  }
}

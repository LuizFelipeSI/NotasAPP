import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'disciplina_detalhes_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username; // Agora o nome de usuário é passado como parâmetro

  const HomeScreen({super.key, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> disciplinas = [
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
  ];

  void atualizarAnotacao(String nome, String anotacao) {
    setState(() {
      final index = disciplinas.indexWhere(
        (disciplina) => disciplina['nome'] == nome,
      );
      if (index != -1) {
        disciplinas[index]['anotacoes'] = anotacao;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Tela Principal'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, ${widget.username}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Suas Disciplinas:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: disciplinas.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      title: Text(
                        disciplinas[index]['nome'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Nota: ${disciplinas[index]['nota']} | Presença: ${disciplinas[index]['presenca']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[600],
                        ),
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.school, color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          _createRoute(
                            DisciplinaDetalhesScreen(
                              disciplina: disciplinas[index],
                              onSalvarAnotacao: atualizarAnotacao,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    _createRoute(const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Sair',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

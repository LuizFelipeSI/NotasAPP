import 'package:flutter/material.dart';
import 'disciplina_detalhes_screen.dart';
import 'login_screen.dart';
import 'package:flutter_application_1/services/database_helper.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final String username;

  const HomeScreen({super.key, required this.userId, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _disciplinas = [];

  @override
  void initState() {
    super.initState();
    _carregarDisciplinas();
  }

  Future<void> _carregarDisciplinas() async {
    final disciplinas = await _dbHelper.getDisciplinas(widget.userId);
    setState(() {
      _disciplinas = disciplinas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      appBar: AppBar(
        title: const Text(
          'Minhas Disciplinas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Olá, ${widget.username}!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Suas Disciplinas:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  _disciplinas.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhuma disciplina cadastrada',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: _disciplinas.length,
                        itemBuilder: (context, index) {
                          return _buildDisciplinaCard(_disciplinas[index]);
                        },
                      ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const LoginScreen(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Sair',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisciplinaCard(Map<String, dynamic> disciplina) {
    // Convertendo os valores numéricos para String
    String nota = disciplina['nota']?.toString() ?? '0.0';
    String presenca = disciplina['presenca']?.toString() ?? '0.0';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final provas = await _dbHelper.getProvas(disciplina['id']);
          final trabalhos = await _dbHelper.getTrabalhos(disciplina['id']);
          final anotacao = await _dbHelper.getAnotacao(disciplina['id']);

          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      DisciplinaDetalhesScreen(
                        disciplina: {
                          'id': disciplina['id'],
                          'nome': disciplina['nome'],
                          'nota': nota, // Usando a string convertida
                          'presenca': presenca, // Usando a string convertida
                          'descricao': disciplina['descricao'],
                          'provas': provas.map((p) => p['data']).toList(),
                          'trabalhos': trabalhos.map((t) => t['data']).toList(),
                          'anotacoes': anotacao?['texto'] ?? '',
                        },
                        dbHelper: _dbHelper,
                      ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: Icon(Icons.school, color: Colors.green[700]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      disciplina['nome'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    'Nota',
                    nota,
                    Icons.grade,
                  ), // Usando a string convertida
                  _buildInfoItem(
                    'Presença',
                    '$presenca%',
                    Icons.people,
                  ), // Adicionando % e usando a string convertida
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green),
        const SizedBox(width: 4),
        Text('$label: $value', style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

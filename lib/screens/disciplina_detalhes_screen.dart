import 'package:flutter/material.dart';

class DisciplinaDetalhesScreen extends StatefulWidget {
  final Map<String, dynamic> disciplina;
  final Function(String, String) onSalvarAnotacao;

  const DisciplinaDetalhesScreen({
    super.key,
    required this.disciplina,
    required this.onSalvarAnotacao,
  });

  @override
  _DisciplinaDetalhesScreenState createState() =>
      _DisciplinaDetalhesScreenState();
}

class _DisciplinaDetalhesScreenState extends State<DisciplinaDetalhesScreen> {
  late TextEditingController _anotacoesController;

  @override
  void initState() {
    super.initState();
    _anotacoesController = TextEditingController(
      text: widget.disciplina['anotacoes'] ?? '',
    );
  }

  @override
  void dispose() {
    _anotacoesController.dispose();
    super.dispose();
  }

  void salvarAnotacao() {
    setState(() {
      widget.onSalvarAnotacao(
        widget.disciplina['nome'],
        _anotacoesController.text,
      );
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Anotação salva!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        title: Text(widget.disciplina['nome']),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.disciplina['nome'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Nota: ${widget.disciplina['nota']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Presença: ${widget.disciplina['presenca']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Descrição:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.disciplina['descricao'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Provas:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (widget.disciplina['provas'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          widget.disciplina['provas']
                              .map<Widget>(
                                (prova) => Text(
                                  '- $prova',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                              .toList(),
                    )
                  else
                    const Text(
                      'Nenhuma prova cadastrada.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    'Trabalhos:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (widget.disciplina['trabalhos'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          widget.disciplina['trabalhos']
                              .map<Widget>(
                                (trabalho) => Text(
                                  '- $trabalho',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                              .toList(),
                    )
                  else
                    const Text(
                      'Nenhum trabalho cadastrado.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    'Anotações:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _anotacoesController,
                    decoration: InputDecoration(
                      hintText: 'Adicione suas anotações...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: salvarAnotacao,
                      child: const Text('Salvar Anotação'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

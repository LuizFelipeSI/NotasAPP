import 'package:flutter/material.dart';
import 'traducao_screen.dart';
import 'package:flutter_application_1/services/database_helper.dart';

class DisciplinaDetalhesScreen extends StatefulWidget {
  final Map<String, dynamic> disciplina;
  final DatabaseHelper dbHelper;

  const DisciplinaDetalhesScreen({
    super.key,
    required this.disciplina,
    required this.dbHelper,
  });

  @override
  _DisciplinaDetalhesScreenState createState() => _DisciplinaDetalhesScreenState();
}

class _DisciplinaDetalhesScreenState extends State<DisciplinaDetalhesScreen> {
  late TextEditingController _anotacoesController;
  late TextEditingController _novaProvaController;
  late TextEditingController _novoTrabalhoController;
  late TextEditingController _editarProvaController;
  late TextEditingController _editarTrabalhoController;
  int? _provaEditandoIndex;
  int? _trabalhoEditandoIndex;
  List<Map<String, dynamic>> _provas = [];
  List<Map<String, dynamic>> _trabalhos = [];

  @override
  void initState() {
    super.initState();
    _anotacoesController = TextEditingController(text: widget.disciplina['anotacoes'] ?? '');
    _novaProvaController = TextEditingController();
    _novoTrabalhoController = TextEditingController();
    _editarProvaController = TextEditingController();
    _editarTrabalhoController = TextEditingController();
    _carregarProvasETrabalhos();
  }

  Future<void> _carregarProvasETrabalhos() async {
    final provas = await widget.dbHelper.getProvas(widget.disciplina['id']);
    final trabalhos = await widget.dbHelper.getTrabalhos(widget.disciplina['id']);
    setState(() {
      _provas = provas;
      _trabalhos = trabalhos;
    });
  }

  @override
  void dispose() {
    _anotacoesController.dispose();
    _novaProvaController.dispose();
    _novoTrabalhoController.dispose();
    _editarProvaController.dispose();
    _editarTrabalhoController.dispose();
    super.dispose();
  }

  Future<void> salvarAnotacao() async {
    await widget.dbHelper.updateAnotacao(
      widget.disciplina['id'],
      _anotacoesController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anotação salva!')));
  }

  Future<void> adicionarProva() async {
    if (_novaProvaController.text.isEmpty) return;
    
    await widget.dbHelper.insertProva(
      widget.disciplina['id'],
      _novaProvaController.text,
    );
    _novaProvaController.clear();
    await _carregarProvasETrabalhos();
  }

  Future<void> removerProva(int index) async {
    await widget.dbHelper.deleteProva(_provas[index]['id']);
    await _carregarProvasETrabalhos();
  }

  Future<void> editarProva(int index) async {
    setState(() {
      _provaEditandoIndex = index;
      _editarProvaController.text = _provas[index]['data'];
    });
  }

  Future<void> salvarEdicaoProva() async {
    if (_provaEditandoIndex == null || _editarProvaController.text.isEmpty) return;
    
    await widget.dbHelper.updateProva(
      _provas[_provaEditandoIndex!]['id'],
      _editarProvaController.text,
    );
    setState(() {
      _provaEditandoIndex = null;
      _editarProvaController.clear();
    });
    await _carregarProvasETrabalhos();
  }

  Future<void> adicionarTrabalho() async {
    if (_novoTrabalhoController.text.isEmpty) return;
    
    await widget.dbHelper.insertTrabalho(
      widget.disciplina['id'],
      _novoTrabalhoController.text,
    );
    _novoTrabalhoController.clear();
    await _carregarProvasETrabalhos();
  }

  Future<void> removerTrabalho(int index) async {
    await widget.dbHelper.deleteTrabalho(_trabalhos[index]['id']);
    await _carregarProvasETrabalhos();
  }

  Future<void> editarTrabalho(int index) async {
    setState(() {
      _trabalhoEditandoIndex = index;
      _editarTrabalhoController.text = _trabalhos[index]['data'];
    });
  }

  Future<void> salvarEdicaoTrabalho() async {
    if (_trabalhoEditandoIndex == null || _editarTrabalhoController.text.isEmpty) return;
    
    await widget.dbHelper.updateTrabalho(
      _trabalhos[_trabalhoEditandoIndex!]['id'],
      _editarTrabalhoController.text,
    );
    setState(() {
      _trabalhoEditandoIndex = null;
      _editarTrabalhoController.clear();
    });
    await _carregarProvasETrabalhos();
  }

  void cancelarEdicao() {
    setState(() {
      _provaEditandoIndex = null;
      _trabalhoEditandoIndex = null;
      _editarProvaController.clear();
      _editarTrabalhoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        title: Text(widget.disciplina['nome']),
        backgroundColor: Colors.green,
        actions: [
          if (widget.disciplina['nome'] == 'Inglês')
            IconButton(
              icon: const Icon(Icons.translate),
              onPressed: () {
                Navigator.push(
                  context, 
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) => 
                      const TraducaoScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
              tooltip: 'Tradutor',
            ),
        ],
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
                  if (_provas.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        _provas.length,
                        (index) {
                          if (_provaEditandoIndex == index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _editarProvaController,
                                    decoration: const InputDecoration(
                                      hintText: 'Editar prova...',
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: salvarEdicaoProva,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: cancelarEdicao,
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '- ${_provas[index]['data']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => editarProva(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removerProva(index),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    )
                  else
                    const Text(
                      'Nenhuma prova cadastrada.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _novaProvaController,
                          decoration: const InputDecoration(
                            hintText: 'Adicionar nova prova...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: adicionarProva,
                      ),
                    ],
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
                  if (_trabalhos.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        _trabalhos.length,
                        (index) {
                          if (_trabalhoEditandoIndex == index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _editarTrabalhoController,
                                    decoration: const InputDecoration(
                                      hintText: 'Editar trabalho...',
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: salvarEdicaoTrabalho,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: cancelarEdicao,
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '- ${_trabalhos[index]['data']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => editarTrabalho(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removerTrabalho(index),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    )
                  else
                    const Text(
                      'Nenhum trabalho cadastrado.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _novoTrabalhoController,
                          decoration: const InputDecoration(
                            hintText: 'Adicionar novo trabalho...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: adicionarTrabalho,
                      ),
                    ],
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
}
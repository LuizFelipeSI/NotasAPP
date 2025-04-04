import 'package:flutter/material.dart';
import 'traducao_screen.dart';

class DisciplinaDetalhesScreen extends StatefulWidget {
  final Map<String, dynamic> disciplina;
  final Function(String, String) onSalvarAnotacao;
  final Function(String, List<String>) onAtualizarProvas;
  final Function(String, List<String>) onAtualizarTrabalhos;

  const DisciplinaDetalhesScreen({
    super.key,
    required this.disciplina,
    required this.onSalvarAnotacao,
    required this.onAtualizarProvas,
    required this.onAtualizarTrabalhos,
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

  @override
  void initState() {
    super.initState();
    _anotacoesController = TextEditingController(text: widget.disciplina['anotacoes'] ?? '');
    _novaProvaController = TextEditingController();
    _novoTrabalhoController = TextEditingController();
    _editarProvaController = TextEditingController();
    _editarTrabalhoController = TextEditingController();
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

  void salvarAnotacao() {
    setState(() {
      widget.onSalvarAnotacao(
        widget.disciplina['nome'],
        _anotacoesController.text,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anotação salva!')));
  }

  void adicionarProva() {
    if (_novaProvaController.text.isEmpty) return;
    
    setState(() {
      widget.disciplina['provas'].add(_novaProvaController.text);
      widget.onAtualizarProvas(widget.disciplina['nome'], List.from(widget.disciplina['provas']));
      _novaProvaController.clear();
    });
  }

  void removerProva(int index) {
    setState(() {
      widget.disciplina['provas'].removeAt(index);
      widget.onAtualizarProvas(widget.disciplina['nome'], List.from(widget.disciplina['provas']));
    });
  }

  void editarProva(int index) {
    setState(() {
      _provaEditandoIndex = index;
      _editarProvaController.text = widget.disciplina['provas'][index];
    });
  }

  void salvarEdicaoProva() {
    if (_provaEditandoIndex == null || _editarProvaController.text.isEmpty) return;
    
    setState(() {
      widget.disciplina['provas'][_provaEditandoIndex!] = _editarProvaController.text;
      widget.onAtualizarProvas(widget.disciplina['nome'], List.from(widget.disciplina['provas']));
      _provaEditandoIndex = null;
      _editarProvaController.clear();
    });
  }

  void adicionarTrabalho() {
    if (_novoTrabalhoController.text.isEmpty) return;
    
    setState(() {
      widget.disciplina['trabalhos'].add(_novoTrabalhoController.text);
      widget.onAtualizarTrabalhos(widget.disciplina['nome'], List.from(widget.disciplina['trabalhos']));
      _novoTrabalhoController.clear();
    });
  }

  void removerTrabalho(int index) {
    setState(() {
      widget.disciplina['trabalhos'].removeAt(index);
      widget.onAtualizarTrabalhos(widget.disciplina['nome'], List.from(widget.disciplina['trabalhos']));
    });
  }

  void editarTrabalho(int index) {
    setState(() {
      _trabalhoEditandoIndex = index;
      _editarTrabalhoController.text = widget.disciplina['trabalhos'][index];
    });
  }

  void salvarEdicaoTrabalho() {
    if (_trabalhoEditandoIndex == null || _editarTrabalhoController.text.isEmpty) return;
    
    setState(() {
      widget.disciplina['trabalhos'][_trabalhoEditandoIndex!] = _editarTrabalhoController.text;
      widget.onAtualizarTrabalhos(widget.disciplina['nome'], List.from(widget.disciplina['trabalhos']));
      _trabalhoEditandoIndex = null;
      _editarTrabalhoController.clear();
    });
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
                Navigator.push(context, _createRoute(const TraducaoScreen()));
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
                  if (widget.disciplina['provas'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        widget.disciplina['provas'].length,
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
                                    '- ${widget.disciplina['provas'][index]}',
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
                  if (widget.disciplina['trabalhos'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        widget.disciplina['trabalhos'].length,
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
                                    '- ${widget.disciplina['trabalhos'][index]}',
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
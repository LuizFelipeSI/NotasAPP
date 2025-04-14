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
  _DisciplinaDetalhesScreenState createState() =>
      _DisciplinaDetalhesScreenState();
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
    _anotacoesController = TextEditingController(
      text: widget.disciplina['anotacoes'] ?? '',
    );
    _novaProvaController = TextEditingController();
    _novoTrabalhoController = TextEditingController();
    _editarProvaController = TextEditingController();
    _editarTrabalhoController = TextEditingController();
    _carregarProvasETrabalhos();
  }

  Future<void> _carregarProvasETrabalhos() async {
    final provas = await widget.dbHelper.getProvas(widget.disciplina['id']);
    final trabalhos = await widget.dbHelper.getTrabalhos(
      widget.disciplina['id'],
    );
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
      const SnackBar(
        content: Text(
          'Anotação salva com sucesso!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
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
    if (_provaEditandoIndex == null || _editarProvaController.text.isEmpty)
      return;

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
    if (_trabalhoEditandoIndex == null ||
        _editarTrabalhoController.text.isEmpty)
      return;

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
      backgroundColor: Colors.lightGreen[200],
      appBar: AppBar(
        title: Text(widget.disciplina['nome']),
        backgroundColor: Colors.green[700],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (widget.disciplina['nome'] == 'Inglês')
            IconButton(
              icon: const Icon(Icons.translate, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const TraducaoScreen(),
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
              tooltip: 'Tradutor',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
                  Row(
                    children: [
                      _buildInfoCard(
                        'Nota',
                        widget.disciplina['nota'],
                        Icons.grade,
                      ),
                      const SizedBox(width: 10),
                      _buildInfoCard(
                        'Presença',
                        widget.disciplina['presenca'],
                        Icons.people,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Descrição:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.disciplina['descricao'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Provas'),
                  const SizedBox(height: 8),
                  if (_provas.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_provas.length, (index) {
                        if (_provaEditandoIndex == index) {
                          return _buildEditItemRow(
                            _editarProvaController,
                            salvarEdicaoProva,
                            cancelarEdicao,
                          );
                        } else {
                          return _buildItemRow(
                            _provas[index]['data'],
                            () => editarProva(index),
                            () => removerProva(index),
                          );
                        }
                      }),
                    )
                  else
                    _buildEmptyState('Nenhuma prova cadastrada'),
                  _buildAddItemRow(
                    _novaProvaController,
                    'Adicionar nova prova...',
                    adicionarProva,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Trabalhos'),
                  const SizedBox(height: 8),
                  if (_trabalhos.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_trabalhos.length, (index) {
                        if (_trabalhoEditandoIndex == index) {
                          return _buildEditItemRow(
                            _editarTrabalhoController,
                            salvarEdicaoTrabalho,
                            cancelarEdicao,
                          );
                        } else {
                          return _buildItemRow(
                            _trabalhos[index]['data'],
                            () => editarTrabalho(index),
                            () => removerTrabalho(index),
                          );
                        }
                      }),
                    )
                  else
                    _buildEmptyState('Nenhum trabalho cadastrado'),
                  _buildAddItemRow(
                    _novoTrabalhoController,
                    'Adicionar novo trabalho...',
                    adicionarTrabalho,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Anotações'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _anotacoesController,
                    decoration: InputDecoration(
                      hintText: 'Adicione suas anotações...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: salvarAnotacao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Salvar Anotação',
                        style: TextStyle(fontSize: 16),
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

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Icon(icon, size: 20, color: Colors.green),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildItemRow(
    String text,
    VoidCallback onEdit,
    VoidCallback onDelete,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Text('- $text', style: const TextStyle(fontSize: 16)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditItemRow(
    TextEditingController controller,
    VoidCallback onSave,
    VoidCallback onCancel,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check, size: 20, color: Colors.green),
              onPressed: onSave,
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.red),
              onPressed: onCancel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddItemRow(
    TextEditingController controller,
    String hintText,
    VoidCallback onAdd,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.green[700],
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 20),
            onPressed: onAdd,
          ),
        ),
      ],
    );
  }
}

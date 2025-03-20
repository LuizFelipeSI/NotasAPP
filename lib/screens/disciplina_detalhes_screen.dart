import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/disciplina_provider.dart'; // Adicione a importação do seu provider

class DisciplinaDetalhesScreen extends StatefulWidget {
  final Map<String, dynamic> disciplina;

  const DisciplinaDetalhesScreen({super.key, required this.disciplina});

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

                // Exibição das provas
                const Text(
                  'Provas:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                widget.disciplina['provas'].isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          widget.disciplina['provas'].map<Widget>((prova) {
                            return Text(
                              '📅 $prova',
                              style: const TextStyle(fontSize: 16),
                            );
                          }).toList(),
                    )
                    : const Text(
                      'Nenhuma prova agendada.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                const SizedBox(height: 20),

                // Exibição dos trabalhos
                const Text(
                  'Trabalhos:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                widget.disciplina['trabalhos'].isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          widget.disciplina['trabalhos'].map<Widget>((
                            trabalho,
                          ) {
                            return Text(
                              '📝 $trabalho',
                              style: const TextStyle(fontSize: 16),
                            );
                          }).toList(),
                    )
                    : const Text(
                      'Nenhum trabalho agendado.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                const SizedBox(height: 20),

                // Anotações
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
                  maxLines:
                      5, // Campo de texto expandido para anotações maiores
                  onChanged: (value) {
                    // Atualizar a anotação no estado (se necessário)
                    setState(() {
                      widget.disciplina['anotacoes'] = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para salvar as anotações, por exemplo, no backend ou banco de dados local
                    Provider.of<DisciplinaProvider>(
                      context,
                      listen: false,
                    ).updateAnotacao(
                      widget.disciplina['nome'],
                      _anotacoesController.text,
                    );

                    // Feedback para o usuário de que a anotação foi salva
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Anotação salva!')),
                    );
                  },
                  child: const Text('Salvar Anotação'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

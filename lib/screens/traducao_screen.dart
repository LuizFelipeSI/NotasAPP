import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TraducaoScreen extends StatefulWidget {
  const TraducaoScreen({super.key});

  @override
  _TraducaoScreenState createState() => _TraducaoScreenState();
}

class _TraducaoScreenState extends State<TraducaoScreen> {
  final TextEditingController _textoController = TextEditingController();
  String _textoTraduzido = '';
  bool _isLoading = false;

  Future<void> _traduzirTexto() async {
    if (_textoController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _textoTraduzido = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(_textoController.text)}&langpair=en|pt',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _textoTraduzido = data['responseData']['translatedText'] ?? 'Tradução não encontrada';
        });
      } else {
        setState(() {
          _textoTraduzido = 'Erro ao traduzir: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _textoTraduzido = 'Erro: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        title: const Text('Tradutor Inglês-Português'),
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
              children: [
                TextField(
                  controller: _textoController,
                  decoration: const InputDecoration(
                    labelText: 'Texto em Inglês',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _traduzirTexto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Traduzir'),
                ),
                const SizedBox(height: 20),
                if (_textoTraduzido.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tradução:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(_textoTraduzido),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }
}
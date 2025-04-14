import 'dart:async';
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
  bool _traduzirParaIngles = false;

  Future<void> _traduzirTexto() async {
    if (_textoController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _textoTraduzido = '';
    });

    try {
      final langpair = _traduzirParaIngles ? 'pt|en' : 'en|pt';
      final url =
          'https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(_textoController.text)}&langpair=$langpair';

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _textoTraduzido =
              data['responseData']['translatedText'] ??
              'Tradução não encontrada';
        });
      } else {
        setState(() {
          _textoTraduzido = 'Erro ao traduzir: ${response.statusCode}';
        });
      }
    } on http.ClientException catch (e) {
      setState(() {
        _textoTraduzido = 'Erro de conexão: ${e.message}';
      });
    } on TimeoutException {
      setState(() {
        _textoTraduzido = 'Tempo excedido ao tentar conectar';
      });
    } catch (e) {
      setState(() {
        _textoTraduzido = 'Erro inesperado';
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
      backgroundColor: Colors.lightGreen[200],
      appBar: AppBar(
        title: const Text('Tradutor', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _traduzirParaIngles ? 'Português' : 'Inglês',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Colors.green[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _traduzirParaIngles ? 'Inglês' : 'Português',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _textoController,
                  decoration: InputDecoration(
                    labelText:
                        _traduzirParaIngles
                            ? 'Texto em Português'
                            : 'Texto em Inglês',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _traduzirParaIngles = !_traduzirParaIngles;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.green[700]!),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Trocar Idioma'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _traduzirTexto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text('Traduzir'),
                      ),
                    ),
                  ],
                ),
                if (_textoTraduzido.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    _traduzirParaIngles
                        ? 'Tradução em Inglês:'
                        : 'Tradução em Português:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      _textoTraduzido,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
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

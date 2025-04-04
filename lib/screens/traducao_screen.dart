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
      debugPrint('URL da API: $url'); // Log para debug

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

      debugPrint('Status code: ${response.statusCode}'); // Log do status
      debugPrint('Response body: ${response.body}'); // Log do corpo

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _textoTraduzido =
              data['responseData']['translatedText'] ??
              'Tradução não encontrada';
        });
      } else {
        setState(() {
          _textoTraduzido =
              'Erro ao traduzir: ${response.statusCode}\n${response.body}';
        });
      }
    } on http.ClientException catch (e) {
      setState(() {
        _textoTraduzido =
            'Erro de conexão: ${e.message}\nVerifique sua internet';
      });
      debugPrint('ClientException: $e');
    } on TimeoutException catch (e) {
      setState(() {
        _textoTraduzido =
            'Tempo excedido ao tentar conectar\nVerifique sua internet';
      });
      debugPrint('TimeoutException: $e');
    } catch (e) {
      setState(() {
        _textoTraduzido = 'Erro inesperado: $e';
      });
      debugPrint('Erro inesperado: $e');
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
        title: const Text('Tradutor Inglês ⇄ Português'),
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
                // Botão compacto de troca de idioma
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.swap_horiz, size: 20),
                    label: Text(
                      _traduzirParaIngles
                          ? 'Português → Inglês'
                          : 'Inglês → Português',
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () {
                      setState(() {
                        _traduzirParaIngles = !_traduzirParaIngles;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(color: Colors.green),
                    ),
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
                    border: const OutlineInputBorder(),
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
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Traduzir'),
                ),
                const SizedBox(height: 20),
                if (_textoTraduzido.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _traduzirParaIngles
                            ? 'Tradução em Inglês:'
                            : 'Tradução em Português:',
                        style: const TextStyle(
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

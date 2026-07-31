import 'package:flutter/material.dart';
import '../core/services/config_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _alturaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarAlturaAtual();
  }

  Future<void> _carregarAlturaAtual() async {
    final alturaSalva = await ConfigService.lerAltura();
    if (alturaSalva != null) {
      _alturaController.text = alturaSalva.toString();
    }
  }

  void _salvar() async {
    final texto = _alturaController.text.replaceAll(',', '.');
    final altura = double.tryParse(texto);

    if (altura == null || altura <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira uma altura válida (ex: 1.75)')),
      );
      return;
    }

    await ConfigService.salvarAltura(altura);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Altura salva com sucesso!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações - Altura')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _alturaController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Sua Altura em metros (ex: 1.75)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar Altura'),
            ),
          ],
        ),
      ),
    );
  }
}

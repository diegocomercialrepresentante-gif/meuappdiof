import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/imc_model.dart';
import '../core/services/config_service.dart';
import 'settings_screen.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  final _pesoController = TextEditingController();
  late Box<ImcModel> _imcBox;

  @override
  void initState() {
    super.initState();
    _imcBox = Hive.box<ImcModel>('imc_box');
  }

  void _calcularEGravar() async {
    final pesoStr = _pesoController.text.replaceAll(',', '.');
    if (pesoStr.isEmpty) return;

    final double? peso = double.tryParse(pesoStr);
    final double? altura = await ConfigService.lerAltura();

    if (altura == null || altura <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, configure sua altura primeiro no ícone de engrenagem!',
          ),
        ),
      );
      return;
    }

    if (peso == null || peso <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Insira um peso válido!')));
      return;
    }

    // Fórmula do IMC: Peso / (Altura * Altura)
    final double imc = peso / (altura * altura);

    final novoImc = ImcModel(
      peso: peso,
      altura: altura,
      imc: imc,
      data: DateTime.now(),
    );

    await _imcBox.add(novoImc);
    _pesoController.clear();
    FocusScope.of(context).unfocus();
  }

  String _classificarImc(double imc) {
    if (imc < 18.5) return 'Abaixo do peso';
    if (imc < 25) return 'Peso normal';
    if (imc < 30) return 'Sobrepeso';
    return 'Obesidade';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pesoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Digite seu Peso atual (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _calcularEGravar,
                icon: const Icon(Icons.calculate),
                label: const Text('Calcular e Salvar IMC'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Histórico de IMC',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _imcBox.listenable(),
                builder: (context, Box<ImcModel> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum registro encontrado.\nConfigure sua altura e calcule o seu IMC!',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final imcItem = box.getAt(index);
                      if (imcItem == null) return const SizedBox.shrink();

                      final classificacao = _classificarImc(imcItem.imc);

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            'IMC: ${imcItem.imc.toStringAsFixed(2)} ($classificacao)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Peso: ${imcItem.peso} kg | Altura: ${imcItem.altura} m\nData: ${imcItem.data.day}/${imcItem.data.month}/${imcItem.data.year} ${imcItem.data.hour}:${imcItem.data.minute.toString().padLeft(2, '0')}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => imcItem.delete(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

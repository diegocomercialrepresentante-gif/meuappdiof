import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static const String _keyAltura = 'altura_usuario';

  // Salvar a altura informada na tela de configurações
  static Future<void> salvarAltura(double altura) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyAltura, altura);
  }

  // Ler a altura salva
  static Future<double?> lerAltura() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyAltura);
  }
}

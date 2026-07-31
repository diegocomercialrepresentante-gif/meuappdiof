import 'dart:io';

// 1. Classe IMC contendo os dados de Peso e Altura (conforme o checklist)
class IMC {
  double _peso = 0.0;
  double _altura = 0.0;

  IMC(this._peso, this._altura);

  double get peso => _peso;
  set peso(double peso) {
    if (peso <= 0) throw Exception("O peso deve ser maior que zero.");
    _peso = peso;
  }

  double get altura => _altura;
  set altura(double altura) {
    if (altura <= 0) throw Exception("A altura deve ser maior que zero.");
    _altura = altura;
  }

  // Método para calcular o IMC
  double calcular() => _peso / (_altura * _altura);

  // Método para obter a classificação
  String obterClassificacao() {
    double imc = calcular();
    if (imc < 18.5) return "Magreza";
    if (imc < 25) return "Saudável (Peso normal)";
    if (imc < 30) return "Sobrepeso";
    if (imc < 35) return "Obesidade Grau I";
    if (imc < 40) return "Obesidade Grau II (severa)";
    return "Obesidade Grau III (mórbida)";
  }
}

// Classe auxiliar para armazenar os dados completos do registro para a lista
class RegistroIMC {
  String nome;
  IMC dadosImc;

  RegistroIMC(this.nome, this.dadosImc);
}

// 2. Funções auxiliares de leitura
String lerString(String mensagem) {
  stdout.write(mensagem);
  String? entrada = stdin.readLineSync();
  if (entrada == null || entrada.trim().isEmpty) {
    throw Exception("Entrada inválida.");
  }
  return entrada.trim();
}

double lerDouble(String mensagem) {
  while (true) {
    try {
      stdout.write(mensagem);
      String? entrada = stdin.readLineSync();
      if (entrada == null) throw Exception("Entrada vazia.");
      double valor = double.parse(entrada.replaceAll(',', '.'));
      if (valor <= 0) {
        print("Erro: O valor deve ser maior que zero.");
        continue;
      }
      return valor;
    } catch (e) {
      print("Erro: Digite um número válido.");
    }
  }
}

// 3. Função principal com suporte a lista e múltiplos cadastros
void main() {
  print("=== Calculadora de IMC (Múltiplos Registros) ===");
  List<RegistroIMC> registros = [];

  bool continuar = true;

  while (continuar) {
    try {
      print("\n--- Novo Cadastro ---");
      String nome = lerString("Digite o nome: ");
      double peso = lerDouble("Digite o peso em kg: ");
      double altura = lerDouble("Digite a altura em metros: ");

      // Criando os objetos conforme o padrão OOP solicitado
      IMC dadosImc = IMC(peso, altura);
      RegistroIMC registro = RegistroIMC(nome, dadosImc);

      // Adicionando à lista
      registros.add(registro);

      print("\nRegistro adicionado com sucesso!");

      String resposta = lerString("Deseja cadastrar outra pessoa? (s/n): ");
      if (resposta.toLowerCase() != 's') {
        continuar = false;
      }
    } catch (e) {
      print("Ocorreu um erro: $e");
    }
  }

  // Exibindo todos os resultados em formato de lista
  print("\n========================================");
  print("          LISTA DE RESULTADOS           ");
  print("======================================2==");

  if (registros.isEmpty) {
    print("Nenhum registro encontrado.");
  } else {
    for (int i = 0; i < registros.length; i++) {
      var reg = registros[i];
      double valorImc = reg.dadosImc.calcular();
      String classificacao = reg.dadosImc.obterClassificacao();

      print("\n[%d] Nome: ${reg.nome}".replaceFirst('%d', '${i + 1}'));
      print(
        "    Peso: ${reg.dadosImc.peso} kg | Altura: ${reg.dadosImc.altura} m",
      );
      print("    IMC: ${valorImc.toStringAsFixed(2)}");
      print("    Classificação: $classificacao");
      print("-" * 40);
    }
  }
}

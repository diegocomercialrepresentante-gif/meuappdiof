import 'dart:io';

class Pessoa {
  String _nome = '';
  double _peso = 0.0;
  double _altura = 0.0;

  Pessoa(this._nome, this._peso, this._altura);

  String get nome => _nome;
  set nome(String nome) {
    if (nome.trim().isEmpty) throw Exception("O nome não pode estar vazio.");
    _nome = nome;
  }

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
}

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

double calcularIMC(double peso, double altura) => peso / (altura * altura);

String obterClassificacaoIMC(double imc) {
  if (imc < 18.5) return "Magreza";
  if (imc < 25) return "Saudável (Peso normal)";
  if (imc < 30) return "Sobrepeso";
  if (imc < 35) return "Obesidade Grau I";
  if (imc < 40) return "Obesidade Grau II (severa)";
  return "Obesidade Grau III (mórbida)";
}

void main(List<String> arguments) {
  print("=== Calculadora de IMC ===");
  try {
    String nome = lerString("Digite seu nome: ");
    double peso = lerDouble("Digite seu peso em kg: ");
    double altura = lerDouble("Digite sua altura em metros: ");

    Pessoa pessoa = Pessoa(nome, peso, altura);
    double imc = calcularIMC(pessoa.peso, pessoa.altura);

    print("\n--- Resultado ---");
    print("Nome: ${pessoa.nome}");
    print("IMC: ${imc.toStringAsFixed(2)}");
    print("Classificação: ${obterClassificacaoIMC(imc)}");
  } catch (e) {
    print("Ocorreu um erro: $e");
  }
}

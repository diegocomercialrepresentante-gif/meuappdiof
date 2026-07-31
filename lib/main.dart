import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/imc_model.dart';
import 'views/imc_screen.dart';

void main() async {
  // Garante que o Flutter está inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive
  await Hive.initFlutter();

  // Registra o adaptador gerado
  Hive.registerAdapter(ImcModelAdapter());

  // Abre a box onde os dados do IMC serão salvos
  await Hive.openBox<ImcModel>('imc_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IMC',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ImcScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

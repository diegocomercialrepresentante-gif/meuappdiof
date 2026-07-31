import 'package:hive/hive.dart';

part 'imc_model.g.dart';

@HiveType(typeId: 0)
class ImcModel extends HiveObject {
  @HiveField(0)
  final double peso;

  @HiveField(1)
  final double altura;

  @HiveField(2)
  final double imc;

  @HiveField(3)
  final DateTime data;

  ImcModel({
    required this.peso,
    required this.altura,
    required this.imc,
    required this.data,
  });
}

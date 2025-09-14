import 'dart:io';
import '../models/Customer.dart';
import 'EmployeeController.dart';
import 'MenuController.dart';

class SystemController {
  final EmployeeController funcionarioController = EmployeeController();

  void start() {
    int? opcao;
    do {
      print("\n=== Sistema de Autoatendimento Cuidapet ===");
      print("1 - Atender Cliente");
      print("2 - Área Restrita (Funcionários)");
      print("0 - Encerrar Sistema");
      stdout.write("Escolha uma opção: ");
      opcao = int.tryParse(stdin.readLineSync() ?? "");

      switch (opcao) {
        case 1:
          _atenderCliente();
          break;
        case 2:
          funcionarioController.acessarAreaRestrita();
          break;
        case 0:
          funcionarioController.exibirRelatorioFinal();
          print("Encerrando sistema...");
          break;
        default:
          print("⚠️ Opção inválida. Tente novamente.");
      }
    } while (opcao != 0);
  }

  void _atenderCliente() {
    stdout.write("Digite seu nome: ");
    final nome = stdin.readLineSync() ?? "Cliente";
    final cliente = Customer(nome);

    print("Olá, $nome! Vamos começar seu atendimento.");
    final menu = MenuController(cliente, funcionarioController);
    menu.exibirMenu();
  }
}

// lib/controllers/funcionario_controller.dart
import 'dart:io';

class EmployeeController {
  static const String senhaAcesso = "cuidapetrestrito";
  int totalClientes = 0;
  double totalFaturado = 0;

  void acessarAreaRestrita() {
    stdout.write("Digite a senha de acesso: ");
    final senha = stdin.readLineSync();

    if (senha != senhaAcesso) {
      print("❌ Senha incorreta. Acesso negado.");
      return;
    }

    print("✅ Acesso concedido à Área Restrita.");
    int? opcao;
    do {
      print("\n===== MENU FUNCIONÁRIO =====");
      print("1 - Registrar venda manual");
      print("2 - Exibir relatório parcial");
      print("0 - Sair da área restrita");
      stdout.write("Escolha uma opção: ");
      opcao = int.tryParse(stdin.readLineSync() ?? "");

      switch (opcao) {
        case 1:
          registrarVenda();
          break;
        case 2:
          exibirRelatorio();
          break;
        case 0:
          print("Saindo da área restrita...");
          break;
        default:
          print("⚠️ Opção inválida.");
      }
    } while (opcao != 0);
  }

  void registrarVenda() {
    stdout.write("Nome do cliente: ");
    final nome = stdin.readLineSync();

    stdout.write("Valor da compra: ");
    final valor = double.tryParse(stdin.readLineSync() ?? "0") ?? 0;

    print("Forma de pagamento:");
    print("1 - Dinheiro (10% de desconto)");
    print("2 - Cartão");
    stdout.write("Escolha: ");
    final forma = int.tryParse(stdin.readLineSync() ?? "0");

    double valorFinal = valor;
    if (forma == 1) {
      valorFinal *= 0.9; // aplica desconto
      print("💰 Pagamento em dinheiro - desconto aplicado.");
    }

    totalClientes++;
    totalFaturado += valorFinal;

    print("✅ Venda registrada para $nome. Valor final: R\$ $valorFinal");
  }

  void registrarVendaAutomatica(String nomeCliente, double valorFinal) {
    totalClientes++;
    totalFaturado += valorFinal;
    print(
      "📊 Venda automática registrada para $nomeCliente. Valor: R\$ $valorFinal",
    );
  }

  void exibirRelatorio() {
    print("\n===== RELATÓRIO PARCIAL =====");
    print("Clientes atendidos: $totalClientes");
    print("Faturamento acumulado: R\$ $totalFaturado");
  }

  void exibirRelatorioFinal() {
    print("\n===== RELATÓRIO FINAL DO DIA =====");
    print("Total de clientes atendidos: $totalClientes");
    print("Faturamento total: R\$ $totalFaturado");
    print("==============================");
  }
}

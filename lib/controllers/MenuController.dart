import 'dart:io';
import '../models/CartItem.dart';
import '../models/Customer.dart';
import '../models/Product.dart';
import '../models/Service.dart';
import 'EmployeeController.dart';

class MenuController {
  final Customer cliente;
  final EmployeeController employeeController;

  final List<Product> produtos = [
    Product(1, "Ração Premium", 120.0),
    Product(2, "Shampoo Pet", 35.0),
    Product(3, "Brinquedo Mordedor", 25.0),
    Product(4, "Coleira Ajustável", 50.0),
  ];

  final List<Service> servicos = [
    Service(101, "Banho", 40.0),
    Service(102, "Tosa", 70.0),
    Service(103, "Consulta Veterinária", 150.0),
  ];

  MenuController(this.cliente, this.employeeController);

  void exibirMenu() {
    int? opcao;
    do {
      print("\n===== MENU PRINCIPAL =====");
      print("1 - Ver promoções de produtos");
      print("2 - Solicitar serviços");
      print("3 - Listar carrinho");
      print("4 - Finalizar carrinho");
      print("0 - Sair");
      stdout.write("Escolha uma opção: ");
      opcao = int.tryParse(stdin.readLineSync() ?? "");

      switch (opcao) {
        case 1:
          listarProdutos();
          adicionarAoCarrinho("produto");
          break;
        case 2:
          listarServicos();
          adicionarAoCarrinho("servico");
          break;
        case 3:
          listarCarrinho();
          break;
        case 4:
          finalizarCarrinho();
          break;
        case 0:
          print("Saindo do atendimento...");
          break;
        default:
          print("⚠️ Opção inválida, tente novamente.");
      }
    } while (opcao != 0);
  }

  void listarProdutos() {
    print("\n--- Produtos em Promoção ---");
    for (var p in produtos) {
      print("${p.id} - ${p.name} (R\$ ${p.price})");
    }
  }

  void listarServicos() {
    print("\n--- Serviços Disponíveis ---");
    for (var s in servicos) {
      print("${s.id} - ${s.description} (R\$ ${s.price})");
    }
  }

  void adicionarAoCarrinho(String tipo) {
    if (cliente.cart.length >= 3) {
      print("⚠️ Você já atingiu o limite de 3 itens no carrinho.");
      return;
    }

    stdout.write("Digite o código do $tipo desejado: ");
    final id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null) {
      print("Código inválido.");
      return;
    }

    if (tipo == "produto") {
      final produto = produtos.firstWhere(
        (p) => p.id == id,
        orElse: () => Product(-1, "inválido", 0),
      );
      if (produto.id != -1) {
        cliente.cart.add(
          CartItem("produto", produto.name, produto.id, produto.price),
        );
        print("✅ Produto adicionado ao carrinho!");
      } else {
        print("⚠️ Produto não encontrado.");
      }
    } else if (tipo == "servico") {
      final servico = servicos.firstWhere(
        (s) => s.id == id,
        orElse: () => Service(-1, "inválido", 0),
      );
      if (servico.id != -1) {
        cliente.cart.add(
          CartItem("servico", servico.description, servico.id, servico.price),
        );
        print("✅ Serviço adicionado ao carrinho!");
      } else {
        print("⚠️ Serviço não encontrado.");
      }
    }
  }

  void listarCarrinho() {
    if (cliente.cart.isEmpty) {
      print("\nCarrinho vazio.");
      return;
    }
    print("\n--- Itens no Carrinho ---");
    double total = 0;
    for (var i in cliente.cart) {
      print(
        "${i.type.toUpperCase()} - Código: ${i.id} | Nome: ${i.name} | R\$ ${i.price}",
      );
      total += i.price;
    }
    print("Total parcial: R\$ $total");
  }

  void finalizarCarrinho() {
    if (cliente.cart.isEmpty) {
      print("⚠️ Carrinho vazio, não é possível finalizar.");
      return;
    }

    double total = cliente.cart.fold(0, (soma, item) => soma + item.price);

    print("\nFormas de pagamento:");
    print("1 - Dinheiro (10% de desconto)");
    print("2 - Cartão");
    stdout.write("Escolha a forma de pagamento: ");
    final opcao = int.tryParse(stdin.readLineSync() ?? "0");

    if (opcao == 1) {
      total *= 0.9; // aplica desconto
      print("💰 Pagamento em dinheiro - desconto aplicado!");
    }

    print("✅ Compra finalizada. Total a pagar: R\$ $total");

    // 🔹 Registrar venda no relatório do funcionário
    employeeController.registrarVendaAutomatica(cliente.name, total);

    cliente.cart.clear();
  }
}

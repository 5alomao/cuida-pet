// lib/controllers/funcionario_controller.dart
import '../utils/InputValidator.dart';
import '../utils/CouponManager.dart';

class EmployeeController {
  static const String accessPassword = "cuidapetrestrito";
  int totalCustomers = 0;
  double totalRevenue = 0;

  void accessRestrictedArea() {
    final password = InputValidator.validatePassword(
      "Digite a senha de acesso: ",
    );

    if (password != accessPassword) {
      print("❌ Senha incorreta. Acesso negado.");
      return;
    }

    print("✅ Acesso concedido à Área Restrita.");
    int? option;
    do {
      print("\n===== MENU FUNCIONÁRIO =====");
      print("1 - Registrar venda manual");
      print("2 - Exibir relatório parcial");
      print("3 - Criar cupom de desconto");
      print("4 - Listar cupons ativos");
      print("0 - Voltar");

      option = InputValidator.validateMenuOption("Escolha uma opção: ", 0, 4);

      switch (option) {
        case 1:
          registerSale();
          break;
        case 2:
          showReport();
          break;
        case 3:
          createCoupon();
          break;
        case 4:
          listCoupons();
          break;
        case 0:
          print("Saindo da área restrita...");
          break;
      }
    } while (option != 0);
  }

  void registerSale() {
    final customerName = InputValidator.validateUserName("Nome do cliente: ");
    final saleValue = InputValidator.validateMonetaryValue(
      "Valor da compra: R\$ ",
    );

    print("\nForma de pagamento:");
    print("1 - Dinheiro (10% de desconto)");
    print("2 - Cartão");

    final paymentForm = InputValidator.validateMenuOption("Escolha: ", 1, 2);

    double finalValue = saleValue;
    String paymentMethod;

    if (paymentForm == 1) {
      finalValue *= 0.9; // aplica desconto
      paymentMethod = "Dinheiro";
      print("💰 Pagamento em dinheiro - desconto aplicado.");
    } else {
      paymentMethod = "Cartão";
    }

    totalCustomers++;
    totalRevenue += finalValue;

    print("✅ Venda registrada para $customerName.");
    print("Valor original: R\$ ${saleValue.toStringAsFixed(2)}");
    if (paymentForm == 1) {
      print(
        "Desconto (10%): R\$ ${(saleValue - finalValue).toStringAsFixed(2)}",
      );
    }
    print("Valor final: R\$ ${finalValue.toStringAsFixed(2)}");
    print("Forma de pagamento: $paymentMethod");
  }

  void createCoupon() {
    print("\n=== CRIAR CUPOM DE DESCONTO ===");

    final couponCode = InputValidator.validateCouponCode(
      "Digite o código do cupom: ",
    );

    if (CouponManager.couponExists(couponCode)) {
      print("⚠️ Cupom já existe! Use um código diferente.");
      return;
    }

    final discountPercentage = InputValidator.validateDiscountPercentage(
      "Digite a porcentagem de desconto (ex: 15): ",
    );

    CouponManager.addCoupon(couponCode, discountPercentage);

    print(
      "✅ Cupom '$couponCode' criado com ${discountPercentage.toStringAsFixed(1)}% de desconto!",
    );
  }

  void listCoupons() {
    print("\n=== CUPONS ATIVOS ===");
    final coupons = CouponManager.getAllCoupons();

    if (coupons.isEmpty) {
      print("Nenhum cupom ativo no momento.");
      return;
    }

    print("Código".padRight(15) + "Desconto");
    print("-" * 25);

    coupons.forEach((code, discount) {
      print("${code.padRight(15)}${discount.toStringAsFixed(1)}%");
    });
  }

  void registerAutomaticSale(String customerName, double finalValue) {
    totalCustomers++;
    totalRevenue += finalValue;
    print(
      "📊 Venda automática registrada para $customerName. Valor: R\$ ${finalValue.toStringAsFixed(2)}",
    );
  }

  void showReport() {
    print("\n===== RELATÓRIO PARCIAL =====");
    print("Clientes atendidos: $totalCustomers");
    print("Faturamento acumulado: R\$ ${totalRevenue.toStringAsFixed(2)}");
  }

  void showFinalReport() {
    print("\n===== RELATÓRIO FINAL DO DIA =====");
    print("Total de clientes atendidos: $totalCustomers");
    print("Faturamento total: R\$ ${totalRevenue.toStringAsFixed(2)}");
    print("==============================");
  }
}

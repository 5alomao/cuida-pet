import '../data/InitialData.dart';
import '../models/CartItem.dart';
import '../models/Customer.dart';
import '../models/Product.dart';
import '../models/Service.dart';
import '../utils/InputValidator.dart';
import '../utils/ReceiptGenerator.dart';
import '../utils/CouponManager.dart';
import 'EmployeeController.dart';

class MenuController {
  final Customer customer;
  final EmployeeController employeeController;

  final List<Product> products = InitialData.getProducts();
  final List<Service> services = InitialData.getServices();

  MenuController(this.customer, this.employeeController);

  bool showMenu() {
    int? option;
    do {
      print("\n===== MENU PRINCIPAL =====");
      print("1 - Ver promoções de produtos");
      print("2 - Solicitar serviços");
      print("3 - Listar carrinho");
      print("4 - Finalizar carrinho");
      print("0 - Voltar");

      option = InputValidator.validateMenuOption("Escolha uma opção: ", 0, 4);

      switch (option) {
        case 1:
          _showProductsMenu();
          break;
        case 2:
          _showServicesMenu();
          break;
        case 3:
          listCart();
          break;
        case 4:
          bool purchaseCompleted = finalizeCart();
          if (purchaseCompleted) {
            return true; // Indica que a compra foi finalizada
          }
          break;
        case 0:
          print("Voltando...");
          break;
      }
    } while (option != 0);
    return false; // Indica que saiu sem finalizar compra
  }

  void _showProductsMenu() {
    int? option;
    do {
      listProducts();
      print("\n1 - Adicionar produto ao carrinho");
      print("0 - Voltar");

      option = InputValidator.validateMenuOption("Escolha uma opção: ", 0, 1);

      if (option == 1) {
        addToCart("produto");
      }
    } while (option != 0);
  }

  void _showServicesMenu() {
    int? option;
    do {
      listServices();
      print("\n1 - Adicionar serviço ao carrinho");
      print("0 - Voltar");

      option = InputValidator.validateMenuOption("Escolha uma opção: ", 0, 1);

      if (option == 1) {
        addToCart("servico");
      }
    } while (option != 0);
  }

  void listProducts() {
    print("\n--- Produtos em Promoção ---");
    for (var p in products) {
      print("${p.id} - ${p.name} (R\$ ${p.price.toStringAsFixed(2)})");
    }
  }

  void listServices() {
    print("\n--- Serviços Disponíveis ---");
    for (var s in services) {
      print("${s.id} - ${s.description} (R\$ ${s.price.toStringAsFixed(2)})");
    }
  }

  void addToCart(String type) {
    if (customer.cart.length >= 3) {
      print("⚠️ Você já atingiu o limite de 3 itens no carrinho.");
      return;
    }

    List<int> validCodes;
    if (type == "produto") {
      validCodes = products.map((p) => p.id).toList();
    } else {
      validCodes = services.map((s) => s.id).toList();
    }

    final id = InputValidator.validateProductServiceCode(
      "Digite o código do $type desejado: ",
      validCodes,
    );

    if (type == "produto") {
      final product = products.firstWhere((p) => p.id == id);
      customer.cart.add(
        CartItem("produto", product.name, product.id, product.price),
      );
      print("✅ Produto '${product.name}' adicionado ao carrinho!");
    } else if (type == "servico") {
      final service = services.firstWhere((s) => s.id == id);
      customer.cart.add(
        CartItem("servico", service.description, service.id, service.price),
      );
      print("✅ Serviço '${service.description}' adicionado ao carrinho!");
    }
  }

  void listCart() {
    if (customer.cart.isEmpty) {
      print("\nCarrinho vazio.");
      return;
    }
    print("\n--- Itens no Carrinho ---");
    print(
      "Tipo".padRight(8) +
          " | " +
          "Cód".padRight(3) +
          " | " +
          "Nome".padRight(15) +
          " | " +
          "Preço".padLeft(10),
    );
    print("-" * 52);

    double total = 0;
    for (var i in customer.cart) {
      String formattedName = i.name.length > 15
          ? "${i.name.substring(0, 12)}..."
          : i.name.padRight(15);

      print(
        "${i.type.toUpperCase().padRight(8)} | ${i.id.toString().padRight(3)} | $formattedName | R\$ ${i.price.toStringAsFixed(2).padLeft(6)}",
      );
      total += i.price;
    }
    print("-" * 52);
    print("Total parcial: R\$ ${total.toStringAsFixed(2)}");
  }

  bool finalizeCart() {
    if (customer.cart.isEmpty) {
      print("⚠️ Carrinho vazio, não é possível finalizar.");
      return false;
    }

    double originalTotal = customer.cart.fold(
      0,
      (sum, item) => sum + item.price,
    );
    double total = originalTotal;

    // Verificar se tem cupom de desconto
    bool hasCoupon = InputValidator.validateConfirmation(
      "Você tem um cupom de desconto?",
    );

    String? appliedCoupon;
    double couponDiscount = 0.0;

    if (hasCoupon) {
      final couponCode = InputValidator.validateCouponCode(
        "Digite o código do cupom: ",
      );
      couponDiscount = CouponManager.getCouponDiscount(couponCode);

      if (couponDiscount > 0) {
        appliedCoupon = couponCode;
        total *= (1 - couponDiscount / 100);
        print(
          "🎟️ Cupom '$couponCode' aplicado! Desconto de ${couponDiscount.toStringAsFixed(1)}%",
        );
      } else {
        print("⚠️ Cupom inválido ou expirado.");
      }
    }

    print("\nFormas de pagamento:");
    print("1 - Dinheiro (10% de desconto adicional)");
    print("2 - Cartão");

    final option = InputValidator.validateMenuOption(
      "Escolha a forma de pagamento: ",
      1,
      2,
    );

    String paymentMethod;
    bool hasMoneyDiscount = false;
    double moneyDiscountValue = 0.0;

    if (option == 1) {
      moneyDiscountValue = total * 0.1;
      total *= 0.9; // aplica desconto
      paymentMethod = "Dinheiro";
      hasMoneyDiscount = true;
      print("💰 Pagamento em dinheiro - desconto adicional aplicado!");
    } else {
      paymentMethod = "Cartão";
    }

    // Gerar e exibir recibo
    _printDetailedReceipt(
      originalTotal: originalTotal,
      total: total,
      paymentMethod: paymentMethod,
      appliedCoupon: appliedCoupon,
      couponDiscount: couponDiscount,
      hasMoneyDiscount: hasMoneyDiscount,
      moneyDiscountValue: moneyDiscountValue,
    );

    print("✅ Compra finalizada com sucesso!");

    // Registrar venda no relatório do funcionário
    employeeController.registerAutomaticSale(customer.name, total);

    customer.cart.clear();
    return true;
  }

  void _printDetailedReceipt({
    required double originalTotal,
    required double total,
    required String paymentMethod,
    String? appliedCoupon,
    required double couponDiscount,
    required bool hasMoneyDiscount,
    required double moneyDiscountValue,
  }) {
    ReceiptGenerator.printReceipt(
      customerName: customer.name,
      items: List.from(customer.cart),
      total: total,
      originalTotal: originalTotal,
      paymentMethod: paymentMethod,
      hasDiscount: hasMoneyDiscount,
      appliedCoupon: appliedCoupon,
      couponDiscount: couponDiscount,
      hasMoneyDiscount: hasMoneyDiscount,
      moneyDiscountValue: moneyDiscountValue,
    );

    // Informações adicionais removidas já que agora estão no recibo
  }
}

import '../models/CartItem.dart';

class ReceiptGenerator {
  static String generateReceipt({
    required String customerName,
    required List<CartItem> items,
    required double total,
    required double originalTotal,
    required String paymentMethod,
    required bool hasDiscount,
    String? appliedCoupon,
    double couponDiscount = 0.0,
    bool hasMoneyDiscount = false,
    double moneyDiscountValue = 0.0,
  }) {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";
    final String formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}";

    StringBuffer receipt = StringBuffer();

    receipt.writeln("=" * 52);
    receipt.writeln("             CUIDAPET - RECIBO DE COMPRA");
    receipt.writeln("=" * 52);
    receipt.writeln("Cliente: $customerName");
    receipt.writeln("Data: $formattedDate");
    receipt.writeln("Hora: $formattedTime");
    receipt.writeln("-" * 52);
    receipt.writeln("ITENS COMPRADOS:");
    receipt.writeln(
      "Tipo".padRight(8) +
          " | " +
          "Cód".padRight(3) +
          " | " +
          "Nome".padRight(15) +
          " | " +
          "Preço".padLeft(10),
    );
    receipt.writeln("-" * 52);

    for (CartItem item in items) {
      String itemType = item.type.toUpperCase();
      String itemName = item.name.length > 15
          ? "${item.name.substring(0, 12)}..."
          : item.name.padRight(15);

      receipt.writeln(
        "${itemType.padRight(8)} | "
        "${item.id.toString().padRight(3)} | "
        "$itemName | "
        "R\$ ${item.price.toStringAsFixed(2).padLeft(6)}",
      );
    }

    receipt.writeln("-" * 52);

    // Mostrar subtotal original
    if (appliedCoupon != null || hasMoneyDiscount) {
      receipt.writeln(
        "Subtotal:".padRight(44) +
            "R\$ ${originalTotal.toStringAsFixed(2).padLeft(6)}",
      );
    }

    // Mostrar desconto do cupom se aplicado
    if (appliedCoupon != null && couponDiscount > 0) {
      double couponDiscountValue = originalTotal * (couponDiscount / 100);
      receipt.writeln(
        "Cupom $appliedCoupon (${couponDiscount.toStringAsFixed(1)}%):"
                .padRight(44) +
            "R\$ ${couponDiscountValue.toStringAsFixed(2).padLeft(6)}",
      );
    }

    // Mostrar desconto em dinheiro se aplicado
    if (hasMoneyDiscount && moneyDiscountValue > 0) {
      receipt.writeln(
        "Desconto Dinheiro (10%):".padRight(44) +
            "R\$ ${moneyDiscountValue.toStringAsFixed(2).padLeft(6)}",
      );
    }

    receipt.writeln(
      "TOTAL:".padRight(44) + "R\$ ${total.toStringAsFixed(2).padLeft(6)}",
    );
    receipt.writeln("-" * 52);
    receipt.writeln("Forma de Pagamento: $paymentMethod");

    // Mostrar informações sobre descontos aplicados
    if (appliedCoupon != null) {
      receipt.writeln(
        "*** CUPOM $appliedCoupon APLICADO (${couponDiscount.toStringAsFixed(1)}%) ***",
      );
    }

    if (hasMoneyDiscount) {
      receipt.writeln("*** DESCONTO DE 10% APLICADO (DINHEIRO) ***");
    }

    receipt.writeln("-" * 52);
    receipt.writeln("Obrigado pela preferência!");
    receipt.writeln("Volte sempre!");
    receipt.writeln("=" * 52);

    return receipt.toString();
  }

  static void printReceipt({
    required String customerName,
    required List<CartItem> items,
    required double total,
    required double originalTotal,
    required String paymentMethod,
    required bool hasDiscount,
    String? appliedCoupon,
    double couponDiscount = 0.0,
    bool hasMoneyDiscount = false,
    double moneyDiscountValue = 0.0,
  }) {
    String receipt = generateReceipt(
      customerName: customerName,
      items: items,
      total: total,
      originalTotal: originalTotal,
      paymentMethod: paymentMethod,
      hasDiscount: hasDiscount,
      appliedCoupon: appliedCoupon,
      couponDiscount: couponDiscount,
      hasMoneyDiscount: hasMoneyDiscount,
      moneyDiscountValue: moneyDiscountValue,
    );

    print("\n$receipt");
  }
}

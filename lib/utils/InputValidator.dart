import 'dart:io';

class InputValidator {
  /// Valida entrada de opção de menu (inteiro)
  static int? validateMenuOption(String prompt, int min, int max) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync() ?? "";

      if (input.trim().isEmpty) {
        print("⚠️ Entrada vazia. Tente novamente.");
        continue;
      }

      // Verifica se contém apenas números
      if (!RegExp(r'^[0-9]+$').hasMatch(input.trim())) {
        print("⚠️ Aceita apenas números. Tente novamente.");
        continue;
      }

      final value = int.tryParse(input.trim());

      if (value == null) {
        print("⚠️ Aceita apenas números. Tente novamente.");
        continue;
      }

      if (value < min || value > max) {
        print("⚠️ Opção inválida. Digite um número entre $min e $max.");
        continue;
      }

      return value;
    }
  }

  /// Valida nome de usuário (não vazio e apenas letras/espaços)
  static String validateUserName(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync() ?? "";

      if (input.trim().isEmpty) {
        print("⚠️ Nome não pode estar vazio. Tente novamente.");
        continue;
      }

      if (input.trim().length < 2) {
        print("⚠️ Nome deve ter pelo menos 2 caracteres.");
        continue;
      }

      // Verifica se contém apenas letras, espaços e acentos
      final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
      if (!nameRegex.hasMatch(input.trim())) {
        print("⚠️ Nome deve conter apenas letras e espaços.");
        continue;
      }

      return input.trim();
    }
  }

  /// Valida valor monetário (positivo)
  static double validateMonetaryValue(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync() ?? "";

      if (input.trim().isEmpty) {
        print("⚠️ Valor não pode estar vazio. Tente novamente.");
        continue;
      }

      // Verifica se contém apenas números, vírgula ou ponto
      if (!RegExp(r'^[0-9]+([,.][0-9]+)?$').hasMatch(input.trim())) {
        print(
          "⚠️ Aceita apenas números (ex: 10.50 ou 10,50). Tente novamente.",
        );
        continue;
      }

      // Substitui vírgula por ponto para aceitar formato brasileiro
      final normalizedInput = input.trim().replaceAll(',', '.');
      final value = double.tryParse(normalizedInput);

      if (value == null) {
        print(
          "⚠️ Aceita apenas números (ex: 10.50 ou 10,50). Tente novamente.",
        );
        continue;
      }

      if (value <= 0) {
        print("⚠️ Valor deve ser maior que zero.");
        continue;
      }

      return value;
    }
  }

  /// Valida código de produto/serviço
  static int validateProductServiceCode(String prompt, List<int> validCodes) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync() ?? "";

      if (input.trim().isEmpty) {
        print("⚠️ Código não pode estar vazio. Tente novamente.");
        continue;
      }

      // Verifica se contém apenas números
      if (!RegExp(r'^[0-9]+$').hasMatch(input.trim())) {
        print("⚠️ Aceita apenas números. Tente novamente.");
        continue;
      }

      final code = int.tryParse(input.trim());

      if (code == null) {
        print("⚠️ Aceita apenas números. Tente novamente.");
        continue;
      }

      if (!validCodes.contains(code)) {
        print(
          "⚠️ Código não encontrado. Códigos válidos: ${validCodes.join(', ')}",
        );
        continue;
      }

      return code;
    }
  }

  /// Valida senha
  static String validatePassword(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync() ?? "";

      if (input.trim().isEmpty) {
        print("⚠️ Senha não pode estar vazia. Tente novamente.");
        continue;
      }

      return input.trim();
    }
  }

  /// Valida confirmação (s/n)
  static bool validateConfirmation(String prompt) {
    while (true) {
      stdout.write("$prompt (s/n): ");
      final input = stdin.readLineSync() ?? "";

      if (input.trim().isEmpty) {
        print("⚠️ Responda com 's' para sim ou 'n' para não.");
        continue;
      }

      final response = input.trim().toLowerCase();

      if (response == 's' || response == 'sim') {
        return true;
      } else if (response == 'n' || response == 'não' || response == 'nao') {
        return false;
      } else {
        print("⚠️ Responda com 's' para sim ou 'n' para não.");
        continue;
      }
    }
  }

  /// Valida código de cupom
  static String validateCouponCode(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync() ?? "";

      if (input.trim().isEmpty) {
        print("⚠️ Código do cupom não pode estar vazio. Tente novamente.");
        continue;
      }

      if (input.trim().length < 3) {
        print("⚠️ Código do cupom deve ter pelo menos 3 caracteres.");
        continue;
      }

      // Verifica se contém apenas letras e números
      final couponRegex = RegExp(r'^[a-zA-Z0-9]+$');
      if (!couponRegex.hasMatch(input.trim())) {
        print("⚠️ Código do cupom deve conter apenas letras e números.");
        continue;
      }

      return input.trim().toUpperCase();
    }
  }

  /// Valida porcentagem de desconto
  static double validateDiscountPercentage(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync() ?? "";

      if (input.trim().isEmpty) {
        print("⚠️ Porcentagem não pode estar vazia. Tente novamente.");
        continue;
      }

      // Verifica se contém apenas números, vírgula ou ponto
      if (!RegExp(r'^[0-9]+([,.][0-9]+)?$').hasMatch(input.trim())) {
        print("⚠️ Aceita apenas números (ex: 10.5 ou 10,5). Tente novamente.");
        continue;
      }

      // Substitui vírgula por ponto para aceitar formato brasileiro
      final normalizedInput = input.trim().replaceAll(',', '.');
      final value = double.tryParse(normalizedInput);

      if (value == null) {
        print("⚠️ Aceita apenas números (ex: 10.5 ou 10,5). Tente novamente.");
        continue;
      }

      if (value <= 0 || value >= 100) {
        print("⚠️ Porcentagem deve ser maior que 0 e menor que 100.");
        continue;
      }

      return value;
    }
  }
}

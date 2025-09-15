import '../models/Customer.dart';
import '../utils/InputValidator.dart';
import 'EmployeeController.dart';
import 'MenuController.dart';

class SystemController {
  final EmployeeController employeeController = EmployeeController();

  void start() {
    int? option;
    do {
      print("\n=== Sistema de Autoatendimento Cuidapet ===");
      print("1 - Atender Cliente");
      print("2 - Área Restrita (Funcionários)");
      print("0 - Encerrar Sistema");

      option = InputValidator.validateMenuOption("Escolha uma opção: ", 0, 2);

      switch (option) {
        case 1:
          _serveCustomer();
          break;
        case 2:
          employeeController.accessRestrictedArea();
          break;
        case 0:
          employeeController.showFinalReport();
          print("Encerrando sistema...");
          break;
      }
    } while (option != 0);
  }

  void _serveCustomer() {
    bool continueService = true;

    while (continueService) {
      final customerName = InputValidator.validateUserName("Digite seu nome: ");
      final customer = Customer(customerName);

      print("Olá, $customerName! Vamos começar seu atendimento.");
      final menu = MenuController(customer, employeeController);
      final purchaseCompleted = menu.showMenu();

      // Se a compra foi finalizada, pergunta se quer atender outro cliente
      if (purchaseCompleted) {
        print("\n" + "=" * 50);
        continueService = InputValidator.validateConfirmation(
          "Deseja atender outro cliente?",
        );
        if (continueService) {
          print("Preparando para próximo atendimento...\n");
        }
      } else {
        // Se saiu sem finalizar compra, retorna ao menu principal
        continueService = false;
      }
    }
  }
}

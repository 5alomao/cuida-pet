import '../models/Product.dart';
import '../models/Service.dart';

class InitialData {
  static List<Product> getProducts() {
    return [
      Product(1, "Ração Premium", 120.0),
      Product(2, "Shampoo Pet", 35.0),
      Product(3, "Brinquedo Mordedor", 25.0),
      Product(4, "Coleira Ajustável", 50.0),
    ];
  }

  static List<Service> getServices() {
    return [
      Service(10, "Banho", 40.0),
      Service(20, "Tosa", 70.0),
      Service(30, "Consulta Veterinária", 150.0),
    ];
  }
}

import 'package:dars_1/services/api_services.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiServices apiProvider = ApiServices();

  Future<List<Product>> getProducts() async {
    final data = await apiProvider.fetchProducts();
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<String>> getCategories() async {
    return await apiProvider.fetchCategories();
  }
}

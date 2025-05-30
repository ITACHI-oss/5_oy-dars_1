import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  final baseUrl = "https://fakestoreapi.com/products";

  //bu joyda apidan productlarni olib keladi
  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    //status 200 bolsa responsga saqlangan productlar jsonda qaytadi
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      //200dan boshqa son kelsa bu ma'lumot tog'ri kelmagan boladi
      throw Exception('Failed to load products');
    }
  }

  // bu apidan categoryalarni get qiladi 
  Future<List<String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/categories'),
    );

    //status 200 bolsa ma'lumotlar list<stringda> jsonda qaytadi
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      //elsega tushsa xatolik!
      throw Exception('Failed to load categories');
    }
  }
}

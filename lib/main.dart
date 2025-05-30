import 'package:dars_1/blocs/products/product_bloc.dart';
import 'package:dars_1/repository/product_repository.dart';
import 'package:dars_1/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final productRepository = ProductRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ProductBloc(productRepository)..add(LoadProducts()),
        child: HomeScreen(),
      ),
    );
  }
}

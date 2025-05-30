import 'package:dars_1/blocs/products/product_bloc.dart';
import 'package:dars_1/repository/product_repository.dart';
import 'package:dars_1/views/screens/details_screen.dart';
import 'package:dars_1/views/widgets/category_filter.dart';
import 'package:dars_1/views/widgets/product_card.dart';
import 'package:dars_1/views/widgets/text_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';
  String selectedCategory = 'All';
  List<String> categories = ['All'];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    final repo = context.read<ProductRepository>();
    final fetched = await repo.getCategories();
    setState(() {
      categories = ['All', ...fetched];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SearchField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CategoryFilter(
                      categories: categories,
                      selectedCategory: selectedCategory,
                      onCategorySelected: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  final filteredProducts =
                      state.products.where((product) {
                        final matchesSearch = product.title
                            .toLowerCase()
                            .contains(searchText);
                        final matchesCategory =
                            selectedCategory == 'All' ||
                            product.category.toLowerCase() ==
                                selectedCategory.toLowerCase();
                        return matchesSearch && matchesCategory;
                      }).toList();

                  if (filteredProducts.isEmpty) {
                    return Center(child: Text('No products found.'));
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        title: product.title,
                        imageUrl: product.image,
                        price: product.price,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is ProductError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Center(child: Text('No products loaded.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

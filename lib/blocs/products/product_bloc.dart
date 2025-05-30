import 'package:dars_1/models/product_model.dart';
import 'package:dars_1/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part "product_state.dart";
part "product_event.dart";

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.getProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}

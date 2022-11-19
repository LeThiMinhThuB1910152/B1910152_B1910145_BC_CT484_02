import 'package:flutter/foundation.dart';
import '../../models/product.dart';
import '../../models/auth_token.dart';
import '../../services/products_service.dart';

class ProductsManager with ChangeNotifier {
  late List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Mango',
      description: 'It is so delicous!',
      price: 10,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/02/23/17/36/mango-1218147__340.png',
      isFavorite: false,
    ),
    Product(
      id: 'p2',
      title: 'Strawberry',
      description: 'It is so sweet!',
      price: 15.25,
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/01/17/22/24/strawberries-3089148__340.jpg',
      isFavorite: true,
    ),
    Product(
      id: 'p3',
      title: 'Lựu',
      description: 'It is good for heath!',
      price: 19.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2018/05/08/20/19/pomegranate-3383814__340.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Grape',
      description: 'Good!',
      price: 14.6,
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/02/27/17/51/grapes-276070__340.jpg',
      isFavorite: true,
    ),
    Product(
      id: 'p5',
      title: 'Pear',
      description: 'It is so sweet!',
      price: 12.3,
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/09/06/03/50/pear-2720106__340.jpg',
      isFavorite: false,
    ),
    Product(
      id: 'p6',
      title: 'Banana',
      description: 'It is so delicous!',
      price: 12.3,
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/06/27/22/21/banana-2449019__340.jpg',
      isFavorite: false,
    ), */
  ];
  final ProductsService _productsService;

  ProductsManager([AuthToken? authToken])
      : _productsService = ProductsService(authToken);

  set authToken(AuthToken? authToken) {
    _productsService.authToken = authToken;
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    _items = await _productsService.fetchProducts(filterByUser);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);
    if (newProduct != null) {
      _items.add(newProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      if (await _productsService.updateProduct(product)) {
        _items[index] = product;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Product? existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _productsService.deleteProduct(id)) {
      _items.insert(index, existingProduct);
      notifyListeners();
    }
  }

  Future<void> toggleFavoriteStatus(Product product) async {
    final savedStatus = product.isFavorite;
    product.isFavorite = !savedStatus;

    if (!await _productsService.saveFavoriteStatus(product)) {
      product.isFavorite = savedStatus;
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  /* void addProduct(Product product) {
    _items.add(
      product.copyWith(
        id: 'p${DateTime.now().toIso8601String()}',
      ),
    );
    notifyListeners();
  }  */

  /* void updateProduct(Product product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  } */

  /* void toggleFavoriteStatus(Product product) {
    final savedStatus = product.isFavorite;
    product.isFavorite = !savedStatus;
  } */

  /* void deleteProduct(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    _items.removeAt(index);
    notifyListeners();
  } */
}

import 'dart:convert';

import 'package:ceylonteaauction/src/model/repository/http_status.dart';
import 'package:ceylonteaauction/src/util/network_util.dart';

class ProductRepository {
  Map<int, Product> products = new Map();
  Map<int, ProductCategory> categories = new Map();

  static final ProductRepository _instance = ProductRepository._internal();

  factory ProductRepository() {
    return _instance;
  }

  ProductRepository._internal();

  Future<void> init() async {
    final response = await NetworkUtils.getRequest('getProductCategories');
    HttpStatus status = HttpStatus.fromJson(json.decode(response.body));
    if (status.status) {
      fromJson(json.decode(response.body));
    }
  }

  void fromJson(Map<String, dynamic> json) {
    List<dynamic> categoryList = json['categories'];
    for (var i = 0; i < categoryList.length; i++) {
      var category = ProductCategory.fromJson(categoryList[i]);
      categories[category.id] = category;
    }
  }

  Future<Product> getProduct(int id) async {
    if (products.containsKey(id)) {
      return products[id];
    }
    final response = await NetworkUtils.getRequest('getProduct?product_id=' +
        id.toString());

    HttpStatus status = HttpStatus.fromJson(json.decode(response.body));
    if (status.status) {
      Product product = Product.fromJson(json.decode(response.body));
      products[product.productId] = product;
      return product;
    }
    return Future.error('Unable to retrieve product.');
  }

  ProductCategory getProductCategory(int id) {
    if (categories.containsKey(id)) {
      return categories[id];
    }
    throw ('Unable to retrieve product category.');
  }

}

class ProductCategory {
  int id;
  String category;
  String subcategory;

  ProductCategory({this.id, this.category, this.subcategory});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
        id: json['category_id'],
        category: json['category'],
        subcategory: json['sub_category']
    );
  }
}

class Product {
  int productId;
  int categoryId;
  String description;
  int sellerId;

  Product({this.productId, this.categoryId, this.description, this.sellerId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        productId: json['product']['product_id'],
        categoryId: json['product']['category_id'],
        description: json['product']['description'],
        sellerId: json['product']['user_id']
    );
  }
}
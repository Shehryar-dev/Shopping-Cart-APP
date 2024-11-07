import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart_app/Model/db_helper.dart';
import 'package:shopping_cart_app/Model/product.dart';

class CartProvider with ChangeNotifier{


  DbHelper dbHelper = DbHelper();


  int _counter = 0;
  int get counter => _counter;




  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>>getCartRecord()async{
    _cart = dbHelper.getCartList();
    return  _cart;
  }

  void _setItems()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('cart_item', _counter);
    preferences.setDouble('total_price', _totalPrice);
    notifyListeners();
  }


  void _getItems()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _counter = preferences.getInt('cart_item')?? 0;
    _totalPrice = preferences.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  //counter
  void addCounter(){
    _counter++;
    _setItems();
    notifyListeners();
  }
  void removeCount(){
    _counter--;
    _setItems();
    notifyListeners();
  }
  int getCounter(){
    _getItems();
    return _counter;
  }

  //totalprice
  void addTotalPrice(double productPrice){
    _totalPrice = _totalPrice + productPrice;
    _setItems();
    notifyListeners();
  }
  void removePrice(double productPrice){
    _totalPrice = _totalPrice - productPrice;
    _setItems();
    notifyListeners();
  }
  double getTotalPrice(){
    _getItems();
    return _totalPrice;
  }

}
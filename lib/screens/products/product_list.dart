import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/Model/db_helper.dart';
import 'package:shopping_cart_app/Model/product.dart';
import 'package:shopping_cart_app/Provider/cart_provider.dart';
import 'package:shopping_cart_app/components/error.dart';
import 'cartscreen.dart';

class product_list extends StatefulWidget {
  const product_list({super.key});

  @override
  State<product_list> createState() => _product_listState();
}

class _product_listState extends State<product_list> {
  List<String> productNames = [
    "Apple",
    "Bananas",
    "Grapes",
    "Kiwi",
    "Mongo",
    "Orange",
    "Pear",
    "Pineapple",
    "Watermelon"
  ];

  List<String> productImages = [
    "apple.png",
    "bananas.png",
    "grapes.png",
    "kiwi.png",
    "mango.png",
    "orange.png",
    "pear.png",
    "pineapple.png",
    "watermelon.png"
  ];

  List<String> productQuantity = [
    "1 Kg",         // Apples
    "1 Dozen",      // Bananas
    "500 g",        // Grapes
    "1 Kg",         // Kiwi
    "1 Kg",         // Mango
    "1 Kg",         // Orange
    "1 Kg",         // Pear
    "1 Piece",      // Pineapple
    "1 Piece"
  ];

  List<int> productPrice = [
    5,
    9,
    10,
    11,
    5,
    7,
    9,
    11,
    6
  ];

  DbHelper? dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final cartDetail = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:const Text('Product List',style: TextStyle(fontSize: 25,letterSpacing: 2.1,fontFamily: 'SF-Pro',color: Color(0xfffffffe)),),
        centerTitle: true,
        iconTheme:const IconThemeData(color: Color(0xffffffff)),

        elevation: 1,
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                  builder: (context,value,child){
                    return Text(value.getCounter().toString(),style:const TextStyle(color: Color(0xffFCFAEE),fontSize: 18,),);
                  },
              ),
              badgeStyle:const badges.BadgeStyle(badgeColor: Color(0xffB8001F)),
              child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cartscreen()));
                  },
                  child:const Icon(Icons.shopping_cart_outlined,size: 35,)),

            ),

          ),
        const  SizedBox(width: 30,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productImages.length,
                  itemBuilder: (context,index){
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                    width: 100,
                                    height: 100,
                                    image: AssetImage('assets/images/${productImages[index]}')),
                                const SizedBox(width: 50,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(productNames[index].toString(),style:const TextStyle(fontFamily: 'SF-Medium',fontSize: 21,color: Color(0xffffffff),letterSpacing: 1.9),),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(productQuantity[index].toString(), style:const TextStyle(fontFamily: 'SF-Medium',fontSize: 18,color: Color(0xffffffff),letterSpacing: 1.9),),
                                          const SizedBox(width: 10,),
                                          Text('(\$${productPrice[index].toString()})', style:const TextStyle(fontFamily: 'SF-Medium',fontSize: 20,color: Color(0xffffffff),letterSpacing: 1.9),),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: (){
                                            dbHelper!.insert(Cart(
                                                id: index,
                                                productId: index.toString(),
                                                productName: productNames[index].toString(),
                                                initialPrice: productPrice[index],
                                                productPrice: productPrice[index],
                                                quantity: 1,
                                                unitTag: productQuantity[index].toString(),
                                                image: productImages[index].toString())
                                            ).then((value){
                                              cartDetail.addTotalPrice(double.parse(productPrice[index].toString()));
                                              cartDetail.addCounter();
                                              if (kDebugMode) {
                                                print('Product add Successfully');
                                              }
                                            }).onError((error, stackTrace){
                                              debugPrint('Error: $error');
                                              Error_snack(message: error.toString()).show(context);
                                            });
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 35,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:const Color(0xff06D001),
                                              borderRadius: BorderRadius.circular(7)
                                            ),
                                            child: const Text('Add to Cart',style: TextStyle(fontFamily: 'SF-Pro',fontSize: 16,fontWeight: FontWeight.w700,color: Color(0xffFCFAEE)),),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
              ),
          ),
        ],
      ),
    );
  }
}

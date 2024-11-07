import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopping_cart_app/Model/db_helper.dart';
import 'package:shopping_cart_app/Model/product.dart';
import 'package:shopping_cart_app/Provider/cart_provider.dart';
import 'package:shopping_cart_app/components/error.dart';
import 'package:shopping_cart_app/components/reusablerow.dart';

class Cartscreen extends StatefulWidget {
  const Cartscreen({super.key});

  @override
  State<Cartscreen> createState() => _CartscreenState();
}

class _CartscreenState extends State<Cartscreen> {
  DbHelper? dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final cartDetail = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:const Text('Cart Detail',style: TextStyle(color: Color(0xfffffffe),),),
        centerTitle: true,
        iconTheme:const IconThemeData(color: Color(0xfffffffe)),
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
                child: const Icon(Icons.shopping_basket_outlined,size: 35,color: Color(0xfffffffe)),
            ),
          ),
          const  SizedBox(width: 30,)
        ],
      ),
      
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(future: cartDetail.getCartRecord(),
                builder: (context,AsyncSnapshot<List<Cart>> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.isEmpty){
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 350,
                          height: 350,
                          alignment: Alignment.center,
                          decoration:const BoxDecoration(),
                          child: Lottie.asset('assets/animation/a.json'),
                        ),
                        const Text('Explore Product',style: TextStyle(fontSize: 24,fontFamily: 'SF-Medium',letterSpacing: 1.5,wordSpacing: 2,color: Color(0xfffffffe)),)

                      ],
                    ),
                  );
                }else{
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
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
                                        image: AssetImage('assets/images/${snapshot.data![index].image.toString()}')),
                                    const SizedBox(width: 50,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data![index].productName.toString(),style:const TextStyle(fontFamily: 'SF-Bold',fontSize: 20,color: Color(0xfffffffe)),),
                                              InkWell(
                                                  onTap: (){
                                                    dbHelper!.deleteProduct(snapshot.data![index].id!);
                                                    cartDetail.removeCount();
                                                    cartDetail.removePrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                  },
                                                  child:const Icon(Icons.delete_outline,color: Color(0xffB8001F),))
                                            ],
                                          ),
                                          const SizedBox(height: 15,),
                                          Row(
                                            children: [
                                              Text(snapshot.data![index].unitTag.toString(), style:const TextStyle(fontFamily: 'SF-Medium',fontSize: 18,color: Color(0xfffffffe)),),
                                              const SizedBox(width: 10,),
                                              Text('(\$${snapshot.data![index].productPrice.toString()})', style:const TextStyle(fontFamily: 'SF-Medium',fontSize: 20,color: Color(0xfffffffe)),),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              width: 105,
                                              height: 35,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color:const Color(0xff06D001),
                                                  borderRadius: BorderRadius.circular(7)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {

                                                          int quantity = snapshot.data![index].quantity!;
                                                          if(quantity > 0){
                                                            int price = snapshot.data![index].initialPrice!;
                                                            quantity--;
                                                            int newPrice = price * quantity;
                                                            dbHelper!.updateProduct(
                                                                Cart(
                                                                    id: snapshot.data![index].id!,
                                                                    productId: snapshot.data![index].productId!,
                                                                    productName: snapshot.data![index].productName!,
                                                                    initialPrice: snapshot.data![index].initialPrice!,
                                                                    productPrice: newPrice,
                                                                    quantity: quantity,
                                                                    unitTag: snapshot.data![index].unitTag!,
                                                                    image: snapshot.data![index].image!
                                                                )
                                                            ).then((value){
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              setState(() {

                                                              });
                                                              cartDetail.removePrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                            }).onError((error, stackTrace){
                                                              if (kDebugMode) {
                                                                print('error: $error');
                                                              }
                                                              Error_snack(message: 'Failed to update product: ${error.toString()}').show(context);
                                                            });
                                                          }else{
                                                            Error_snack(message: 'Please add at least one item before proceeding.').show(context);
                                                          }

                                                        },
                                                        child:const Icon(Icons.remove,color:Color(0xffFCFAEE),size: 26,)),
                                                    Text(snapshot.data![index].quantity.toString(),style:const TextStyle(color: Color(0xffFCFAEE),fontSize: 20,fontFamily: 'SF-Pro'),),
                                                    InkWell(
                                                        onTap: () {
                                                          int quantity = snapshot.data![index].quantity!;
                                                          int price = snapshot.data![index].initialPrice!;
                                                          quantity++;
                                                          int newPrice = price * quantity;
                                                          dbHelper!.updateProduct(
                                                              Cart(
                                                                  id: snapshot.data![index].id!,
                                                                  productId: snapshot.data![index].productId!,
                                                                  productName: snapshot.data![index].productName!,
                                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                                  productPrice: newPrice,
                                                                  quantity: quantity,
                                                                  unitTag: snapshot.data![index].unitTag!,
                                                                  image: snapshot.data![index].image!
                                                              )
                                                          ).then((value){
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            setState(() {

                                                            });
                                                            cartDetail.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                          }).onError((error, stackTrace){
                                                            if (kDebugMode) {
                                                              print('error: $error');
                                                            }
                                                            Error_snack(message: error.toString()).show(context);
                                                          });

                                                        },
                                                        child:const Icon(Icons.add,color: Color(0xffFCFAEE),size: 26,)),
                                                  ],
                                                ),
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
                  );
                }

              }else{
                return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index){
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade700,
                        highlightColor: Colors.grey.shade100,
                        child:Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                dense: true,
                                title: Container(height: 10,width: 20,color: Colors.white,),
                                subtitle:Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(height: 15,width: 40,color: Colors.grey,),
                                    Container(height: 15,width: 40,color: Colors.white,),
                                  ],
                                ) ,
                                trailing: const Column(
                                  children: [
                                     SizedBox(height: 20,),
                                     SizedBox(width: 80,
                                    height: 50,)
                                  ],
                                ),
                                leading: Container(height: 150,width: 100,color: Colors.white,),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                );
              }
            
            
            
            }
            
            ),
          ),
          
          Consumer<CartProvider>(builder: (context, val, child){
            return Visibility(
              visible:val.getTotalPrice().toStringAsFixed(2) == '0.00' ? false : true,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableRow(title: 'Sub total: ', value: r'$'+val.getTotalPrice().toStringAsFixed(2)),
                      ReusableRow(
                        title: 'Discount (5%): ',
                        value: r'-$' + (val.getTotalPrice() * 0.05).toStringAsFixed(2),
                      ),
                      ReusableRow(
                        title: 'Total Amount: ',
                        value: r'$' + (val.getTotalPrice() - (val.getTotalPrice() * 0.05)).toStringAsFixed(2),
                      ),

                    ],
                  ),
                ),
              ),
            );
          })
        ],
      ),

    );
  }
}

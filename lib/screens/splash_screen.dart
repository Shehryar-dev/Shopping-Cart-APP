import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:lottie/lottie.dart';
import 'package:shopping_cart_app/Screens/Products/product_list.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  late final AnimationController _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this)..repeat();

   @override
   void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      Timer(const Duration(seconds: 10), (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const product_list()));
      });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration:const BoxDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
                AnimatedBuilder(
                    animation: _animationController,
                    builder: (BuildContext context, Widget? child ){
                      return Transform.rotate(

                          angle: _animationController.value * 2.0 * math.pi,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration:const BoxDecoration(),
                            child: Lottie.asset('assets/animation/animation.json'),
                          )
                      );
                    }
                ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'SF-Pro',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  wordSpacing: 4.5,
                  letterSpacing: 2.5
                ),
                textAlign: TextAlign.center,
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText('Shopping\nCart App',textAlign: TextAlign.center,speed:const Duration(milliseconds:80 )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

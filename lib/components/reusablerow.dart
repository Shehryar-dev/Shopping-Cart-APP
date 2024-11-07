import 'package:flutter/material.dart';

class ReusableRow extends StatelessWidget {
  final String title, value;

  const ReusableRow({required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(),
      width: double.infinity,
      
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title, style:const TextStyle(fontSize: 19,fontFamily: 'SF-Pro',fontWeight: FontWeight.w700,color: Color(0xfffffffe)),),
              // SizedBox(width: 50,),
              Text(value, style:const TextStyle(fontSize: 19,fontFamily: 'SF-Pro',fontWeight: FontWeight.w700,color: Color(0xfffffffe)),),
            ],
          ),
        ),
      ),
    );
  }
}

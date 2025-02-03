import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class SubComponent2 extends StatelessWidget {

  IconData iconCode;
  String title; 
  String subTitle;
  SubComponent2(this.iconCode, this.title, this.subTitle, {super.key});


  @override
  Widget build(BuildContext context) {
  return Padding(
              padding: const EdgeInsets.only(left: 10.0,top: 10.0),
              child: Row(
                children: [

                 Padding(
                   padding: const EdgeInsets.all(5.0),
                   child: Icon( iconCode,size: 32,color: Colors.blue),
                 ),

                 Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(title,style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: "TimesNewRoman"),),
                     Text(subTitle,style: const TextStyle(fontSize: 12,fontFamily: "TimesNewRoman"),)
                   ],
                 )
                ],
              ),
            );
  }
}

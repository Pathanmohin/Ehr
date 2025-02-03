

import 'package:ehr/Dashboard/Claimcomponent/subcomponent.dart';
import 'package:ehr/Dashboard/Claimcomponent/submenu.dart';
import 'package:flutter/material.dart';

class ComponentHome3 extends StatelessWidget {

 final IconData iconCode;
 final String title;
 final String subTitle;

  final String img1;
  final String titel1;

    final String img2;
  final String titel2;

  // final String img;
  // final String titel3;
  

  const ComponentHome3({super.key, required this.iconCode, required this.title, required this.subTitle, required this.img1, required this.titel1, required this.img2, required this.titel2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
      child: Container(
        height: 140,
        width: 450,   
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          
           
           color: Colors.white,

           boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],

        ),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SubComponent3(iconCode,title,subTitle),

            const SizedBox(height: 10,),

            SubMenu3(img1,titel1,img2,titel2),

          ],
        ),
      ),
    );
  }
}
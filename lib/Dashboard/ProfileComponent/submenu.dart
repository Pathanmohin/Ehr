import 'package:ehr/Dashboard/ChangePassword.dart';
import 'package:ehr/Dashboard/Directory.dart';
import 'package:ehr/Dashboard/PersonalDetails.dart';
import 'package:flutter/material.dart';

class SubMenu1 extends StatelessWidget {  

  final String img1;
  final String titel1;

  final String img2;
  final titel2;

  final String img;
  final String titel3;

  const SubMenu1(this.img1, this.titel1, this.img2, this.titel2, this.img, this.titel3, {super.key});
  
  @override
  Widget build(BuildContext context) {

  
    return Padding(
      padding:  const EdgeInsets.all(8.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
      
           InkWell(
            onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>  Personaldetails()));

            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img1"),),
                Text(titel1,style:const TextStyle(fontFamily: "TimesNewRoman"),),
                
              ],
            ),
          ),
          
      
          InkWell(
            onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>  Changepassword()));

            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img2"),),
                Text(titel2,style:const TextStyle(fontFamily: "TimesNewRoman"),),
                
              ],
            ),
          ),
          
      
           InkWell(
            onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>  DirectoryPage()));

            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img"),),
                Text(titel3,style:const TextStyle(fontFamily: "TimesNewRoman"),),
                
              ],
            ),
          ),
          
          
        ],
      ),
    );
  }
}

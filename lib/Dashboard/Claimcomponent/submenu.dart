
import 'package:ehr/Dashboard/BREClaim.dart';
import 'package:ehr/Dashboard/Travel%20Request/Traveldashboard.dart';
import 'package:flutter/material.dart';

class SubMenu3 extends StatelessWidget {  

  final String img1;
  final String titel1;

  final String img2;
  final titel2;

  // final String img;
  // final String titel3;

  const SubMenu3(this.img1, this.titel1, this.img2, this.titel2, {super.key});
  
  @override
  Widget build(BuildContext context) {

  
    return Padding(
      padding:  const EdgeInsets.all(8.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
      
           InkWell(
            onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>  Traveldashboard()));

            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img1"),),
                Text(titel1,style:TextStyle(fontFamily: "TimesNewRoman"),),
                
              ],
            ),
          ),
          
      
          InkWell(
            onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>  BreclaimPage()));

            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img2"),),
                Text(titel2,style:TextStyle(fontFamily: "TimesNewRoman"),),
                
              ],
            ),
          ),
          
      
//            InkWell(
//             onTap: (){
// //Navigator.push(context, MaterialPageRoute(builder: (context)=> const BBPS()));

//             },
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 42,
//                   width: 42,
//                   child: Image.asset("assets/images/$img"),),
//                 Text(titel3,style:TextStyle(fontFamily: "TimesNewRoman"),),
                
//               ],
//             ),
//           ),
          
          
        ],
      ),
    );
  }
}

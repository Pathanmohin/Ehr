
import 'package:badges/badges.dart' as badges;
import 'package:ehr/Dashboard/Attendance.dart';
import 'package:ehr/Dashboard/LeaveDashboard.dart';
import 'package:ehr/Dashboard/SalarySlip.dart';

import 'package:flutter/material.dart';

class SubMenu extends StatelessWidget {  

  final String img1;
  final String titel1;

  final String img2;
  final titel2;

  final String img;
  final String titel3;

 

  const SubMenu(this.img1, this.titel1, this.img2, this.titel2, this.img, this.titel3, {super.key});
  
  @override
  Widget build(BuildContext context,{String? badgeContent}) {

  
    return Padding(
      padding:  const EdgeInsets.all(8.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
           InkWell(
            onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>  AttendancePage()));
            },
             child:badges.Badge(
             showBadge: badgeContent != null,
             badgeContent: badgeContent != null
             ? Text(
                badgeContent,
                style: TextStyle(color: Colors.white),
              )
            : null,
            position: badges.BadgePosition.topEnd(top: -10, end: -10),
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img1"),),
                Text(titel1,style:TextStyle(fontFamily: "TimesNewRoman"),),
                
              ],
            ),
          ),),
          
      
          InkWell(
            onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>  Leavedashboard()));

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
          
      
           InkWell(
            onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>  Salaryslip()));

            },
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: Image.asset("assets/images/$img"),),
                Text(titel3,style:TextStyle(fontFamily: "TimesNewRoman"),),
                
              ],
            ),
          ),
          
          
        ],
      ),
    );
  }
}

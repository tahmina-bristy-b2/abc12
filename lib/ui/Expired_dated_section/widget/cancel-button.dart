
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CancelButtonWidget extends StatelessWidget {
 final double buttonHeight;
 final String buttonName;
 final double fontSize;
 final Color fontColor;
 final Color borderColor;
 final void Function() onTapFuction;  

 const  CancelButtonWidget({super.key,required this.buttonHeight,required this.fontColor,required this.buttonName,required this.fontSize,required this.onTapFuction,required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFuction,
      child: Container(
        height: buttonHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
           border: Border.all(
            width: 2,
            color: borderColor
         )
      ),
       child:Center(child:  Text(buttonName,style: TextStyle(color: fontColor,fontSize: fontSize,fontWeight: FontWeight.bold),)),
    ),
    );
  }
}
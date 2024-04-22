
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomtextFormFiledWidget extends StatelessWidget {
 TextEditingController controller;
 
 FocusNode focusNode;
 TextAlign textAlign;
 TextStyle textStyle;
 TextInputType? keyboardType;
 Widget? suffixIcon;
 String hinText;
 void Function(String)? onChanged;
 void Function()? onTap;

   CustomtextFormFiledWidget({
      super.key,
      required this.controller,
      required this.textAlign,
      required this.textStyle,
      required this.hinText,
      required this.keyboardType,
      this.suffixIcon,
      this.onChanged,
      this.onTap,
      required this.focusNode,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 230, 244, 243),
      ),
      child: TextFormField(
                            
                                    autofocus:false,
                                    controller: controller,
                                    focusNode:hinText==""? focusNode:null,
                                    readOnly:hinText==""?true:false ,
                                    style:textStyle,
                                    textAlign:textAlign,
                                    keyboardType: hinText=="----Enter e-CME Amount ----"? TextInputType.number: TextInputType.text,
                                      inputFormatters: hinText=="----Enter e-CME Amount ----"? [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]:[],
                                    decoration: InputDecoration(
                                      hintText: hinText,
                                       border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      suffixIcon: suffixIcon,
                                      
                                    ),
                                    onChanged: onChanged,
                                    onTap: onTap
               ),
    );
  }
}
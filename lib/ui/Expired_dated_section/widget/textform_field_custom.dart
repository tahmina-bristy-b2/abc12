import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldCustomOrderInput extends StatelessWidget {
  final String hintText;
  final Color borderColor;
  final TextAlign textAlign;
  final bool readOnly;
  final TextEditingController controller;
  final void Function(dynamic) validator; 
  final void Function() afterClickingDone; 

  const TextFormFieldCustomOrderInput({
      super.key,required this.hintText, 
      required this.borderColor,
      required this.readOnly,
      required this.textAlign,
      required this.controller,
      required this.validator,
      required this.afterClickingDone
    });

  @override
  Widget build(BuildContext context) {
                       return TextFormField(
                                   autofocus: false,
                                             textDirection: TextDirection.rtl,
                                              decoration: InputDecoration(
                                                
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                hintText: hintText,
                                                hintStyle:const TextStyle(fontSize: 14),
                                                     contentPadding: EdgeInsets.zero,
                                                enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, 
                                                    color: borderColor,
                                                 ), 
                                                ),
                                                focusedBorder:const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, 
                                                    color: Colors.teal,
                                                 ), 
                                                ),
                                             ),
                                              
                                             controller:  controller,
                                             textAlign: textAlign,
                                             readOnly: readOnly,
                                             inputFormatters: [
                                             hintText!=   "---batch id---"?  FilteringTextInputFormatter.digitsOnly: FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
                                            ],
                                         
                                             style:const TextStyle(fontSize: 14),
                                             keyboardType:hintText!= "---batch id---"? TextInputType.number:TextInputType.text,
                                             onChanged: validator,
                                             onEditingComplete:afterClickingDone ,
                                                             
                                        );
  }
}
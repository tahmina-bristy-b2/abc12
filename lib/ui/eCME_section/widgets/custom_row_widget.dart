import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetBreakDownRowWidget extends StatelessWidget {
  String routingName;
  String rowNumber;
  String reason;
  TextEditingController controller;
  void Function(String)? onChanged;
  String? Function(String?)? validator;

   BudgetBreakDownRowWidget({
    super.key,
    required this.routingName,
    required this.rowNumber,
    required this.reason,
    required this.controller,
    required this.onChanged,
    required this.validator
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6,left: 10,right: 10),
      child: Row(
                                    children: [
                                      SizedBox(
                                        width:MediaQuery.of(context).size.width / 9 ,
                                        child: Text(rowNumber),
    
                                      ),
                                      SizedBox(
                                        width:MediaQuery.of(context).size.width / 3 ,
                                        child: Text(reason),
                                        
                                      ),
                                       SizedBox(
                                        width:MediaQuery.of(context).size.width / 9 ,
                                        child:const Text(":"),
                                        
                                      ),
                                      SizedBox(
                                        height: 50,
                                         width:MediaQuery.of(context).size.width / 3,
                                        child: TextFormField(
                                          readOnly:rowNumber=="3"? true:false ,
                                          inputFormatters:routingName=="participants"? [
                                             FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                          ]:[
                                             FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                                          ],
                                          textAlign: TextAlign.right,
                                          style:const TextStyle(fontSize: 14, color: Colors.black),
                                          controller: controller,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide:
                                                  const BorderSide(
                                                    color: Colors.teal
                                                    ),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          onChanged:  onChanged,
                                          validator: validator,
                                          
                                  
                                     ),
                                  
                                  ),
                                      
    
                                    ],
                                  ),
    );
  }
}
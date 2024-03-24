import 'package:flutter/material.dart';

class BudgetBreakDownRowWidget extends StatelessWidget {
  String rowNumber;
  String reason;
  TextEditingController controller;
  void Function(String)? onChanged;

   BudgetBreakDownRowWidget({
    super.key,
    required this.rowNumber,
    required this.reason,
    required this.controller,
    required this.onChanged
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
                                        height: 45,
                                         width:MediaQuery.of(context).size.width / 3,
                                        child: TextFormField(
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
                                  
                                     ),
                                  
                                  ),
                                      
    
                                    ],
                                  ),
    );
  }
}
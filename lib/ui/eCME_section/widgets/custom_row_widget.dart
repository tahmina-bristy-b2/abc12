import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetBreakDownRowWidget extends StatelessWidget {
 final bool isBillEdit;
 final String routingName;
 final String rowNumber;
 final String reason;
 final TextEditingController controller;
 final TextEditingController? controllerForBillEdit;
 final void Function(String)? onChanged;
 final String? Function(String?)? validator;
  final bool? isprint;

  const  BudgetBreakDownRowWidget({
      super.key,
      this.isBillEdit=false,
      required this.routingName,
      required this.rowNumber,
      required this.reason,
      required this.controller,
      this.controllerForBillEdit,
      required this.onChanged,
      required this.validator,
      this.isprint=false
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6,left: 10,right: 10),
      child: Row(
                                    children: [
                                      SizedBox(
                                        width: isBillEdit==false?  MediaQuery.of(context).size.width /  9 : MediaQuery.of(context).size.width /  11,
                                        child: Text(rowNumber,),
    
                                      ),
                                      SizedBox(
                                        width: isBillEdit==false?   MediaQuery.of(context).size.width / 3 : MediaQuery.of(context).size.width / 4.7,
                                        child: Text(reason,  style:   isBillEdit==true? const TextStyle(fontSize:13, color: Colors.black):null),
                                        
                                      ),
                                       SizedBox(
                                        width: isBillEdit==false?    MediaQuery.of(context).size.width / 9 :MediaQuery.of(context).size.width / 11 ,
                                        child:const Text(":"),
                                        
                                      ),
                                      
                                       isBillEdit==false? const SizedBox(): SizedBox(
                                        height: 50,
                                        width: isBillEdit==false?   MediaQuery.of(context).size.width / 3 : MediaQuery.of(context).size.width / 4,
                                        child: Container(
                                          color:const Color.fromARGB(255, 230, 244, 243),
                                          child: TextFormField(
                                            readOnly:(rowNumber=="3" || reason=="Cost per doctor "||  isBillEdit==true)? true:false ,
                                            inputFormatters:routingName=="participants"? [
                                               FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                            ]:[
                                               FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                                            ],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontSize:isBillEdit==true?13: 14, color: Colors.black),
                                            controller:isBillEdit==true?controllerForBillEdit: controller,
                                            keyboardType: TextInputType.number,
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
                                  
                                      ),
                                      isBillEdit==false? const SizedBox(): const SizedBox(width: 5,),
                                      SizedBox(
                                        height: 50,
                                        width: isBillEdit==false?   MediaQuery.of(context).size.width / 3 : MediaQuery.of(context).size.width / 4.1,
                                        child: TextFormField(
                                          readOnly:(rowNumber=="3" || reason=="Cost per doctor "|| isprint==true)? true:false ,
                                          inputFormatters:routingName=="participants"? [
                                             FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                          ]:[
                                             FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                                          ],
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize:isBillEdit==true?13: 14, color: Colors.black),
                                          controller: controller,
                                          keyboardType: TextInputType.number,
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
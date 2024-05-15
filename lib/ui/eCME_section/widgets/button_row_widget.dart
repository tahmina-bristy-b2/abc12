
import 'package:flutter/material.dart';
class ButtonRowWidget extends StatelessWidget {
  final double buttonheight;
  final double buttonwidth;
  final String firstButtonTitle;
  final Color firstButtonColor;
  final void Function() firstButtonAction;
  final String secondButtonTitle;
  final Color secondButtonColor;
  final void Function() secondButtonAction;
  final bool isRowShow;
  final bool isEditButtonHide;

  const ButtonRowWidget({
    Key? key,
    required this.buttonheight,
    required this.buttonwidth,
    required this.firstButtonTitle,
    required this.firstButtonColor,
    required this.firstButtonAction,
    required this.secondButtonTitle,
    required this.secondButtonColor,
    required this.secondButtonAction,
    required this.isRowShow,
    this.isEditButtonHide=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        isEditButtonHide==false?  ElevatedButton(
                            onPressed: firstButtonAction,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: firstButtonColor,
                                fixedSize:  Size( buttonwidth,buttonheight,)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                               const Icon(Icons.edit, size: 18),
                               const SizedBox(
                                  width: 8,
                                ),
                                FittedBox(
                                  child: Text(firstButtonTitle,
                                      style:const TextStyle(
                                           fontSize: 12,
                                          color: Color.fromARGB(255, 241, 240, 240))),
                                ),
                              ],
                            ),
                          ):const SizedBox(),
                          // const SizedBox(width: 10,),
                          isRowShow == false
                              ? 
                              
                              ElevatedButton(
                                  onPressed: secondButtonAction,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          secondButtonColor,
                                      fixedSize:  Size(
                                        isEditButtonHide==false?
                                         buttonwidth:buttonwidth*2*1,
                                        buttonheight,)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                     const Icon(Icons.cloud_done, size: 18),
                                    const SizedBox(
                                        width: 8,
                                      ),
                                      Text(secondButtonTitle,
                                          style:const TextStyle(
                                            fontSize: 12,
                                              color:
                                                  Color.fromARGB(255, 241, 240, 240))),
                                    ],
                                  ),
                                )
                              : const Center(child: CircularProgressIndicator()),
                        ],
                      );
  }
}

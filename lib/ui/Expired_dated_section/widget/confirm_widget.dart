import 'package:flutter/widgets.dart';
class ConfirmButtonWidget extends StatelessWidget {
  double buttonHeight;
  String buttonName;
  double fontSize;
  Color fontColor;
    final void Function() onTapFuction;  


   ConfirmButtonWidget({super.key,required this.buttonHeight,required this.fontColor,required this.buttonName,required this.fontSize,required this.onTapFuction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFuction,
      child: Container(
                              height: buttonHeight,
                              
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 82, 179, 98),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child:Center(child:  Text(buttonName,style: TextStyle(color: fontColor,fontSize: fontSize,fontWeight: FontWeight.bold),)),
                            ),
    );
  }
}
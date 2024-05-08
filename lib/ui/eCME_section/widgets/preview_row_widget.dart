import 'package:flutter/material.dart';
class RowForCMEPreview extends StatelessWidget {

 final String title ;
 final String value;
 final Color fontColor;
 final bool isBold;
  const RowForCMEPreview({
     super.key,
     required this.title,
     required this.value,
     this.fontColor=Colors.black,
     required this.isBold
    });

  @override
  Widget build(BuildContext context) {
    return  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Expanded(flex: 5, child: Text(title,style: const TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(value == null
                          ? ""
                          : '  $value',style: isBold==true? const TextStyle(fontWeight:FontWeight.bold ):null, ),
                    ),
                  ],
                ),
              );
  }
}



class PreviewBreakdownRowWidget extends StatelessWidget {
 final String title ;
 final String value;
 const PreviewBreakdownRowWidget({
     super.key,
     required this.title,
     required this.value

    });

  @override
  Widget build(BuildContext context) {
    return  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 10, child: Text(title,style: const TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                           flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(value,style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    );
  }
}



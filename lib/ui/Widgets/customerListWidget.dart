import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CustomerListCardWidget extends StatelessWidget {
  final String clientName;
  final bool boolIcon;
  final Icon icon;
  final VoidCallback onPressed;
  final String base;
  final String marketName;
  final String outstanding;
  final bool? magic;
  final List? magicBrand;
  final ConfettiController? confettiController;
  const CustomerListCardWidget(
      {Key? key,
      required this.clientName,
      required this.boolIcon,
      required this.icon,
      required this.onPressed,
      required this.base,
      required this.marketName,
      required this.outstanding,
      this.magic,
      this.magicBrand,
      this.confettiController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return magic == true
        ? Card(
            // elevation: 2,
            // color: Colors.yellow.shade50,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clientName,
                              style: const TextStyle(
                                //     color: Color.fromARGB(255, 0, 174, 29)
                                //     // color: Color(0xff4100E0),
                                //     // color: const Color.fromARGB(255, 138, 201, 149),
                                //     // color: Color.fromARGB(255, 30, 66, 77),
                                fontSize: 16,
                                //     // fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$base, $marketName',
                              style: const TextStyle(color: Colors.grey
                                  // color: Color.fromARGB(255, 86, 173, 100)
                                  // color: Color.fromARGB(255, 150, 121, 224),
                                  // color: Color.fromARGB(255, 30, 66, 77),
                                  ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Transform(
                            transform: Matrix4.rotationY(
                                0.2), // Adjust the rotation angle
                            child: Opacity(
                              opacity: 0.6,
                              child: Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/icons/m.png',
                                    ), // Replace with your image path
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.green,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.only(right: 10, left: 10),
                          //   child: SizedBox(
                          //     height: 30,
                          //     child: Image.asset(
                          //       'assets/icons/m.png',
                          //       //color: Colors.deepOrange,
                          //     ),
                          //   ),
                          // ),
                          // Transform(
                          //   alignment: Alignment.center,
                          //   transform:
                          //       Matrix4.rotationZ(3.1415926535897932 / 4),
                          //   child: SizedBox(
                          //       height: 40,
                          //       child: Image.asset(
                          //         'assets/images/m.png',
                          //         //color: Colors.deepOrange,
                          //       )),
                          // ),

                          boolIcon
                              ? IconButton(onPressed: onPressed, icon: icon)
                              : const SizedBox.shrink(),
                        ],
                      )
                    ],
                  ),
                ),
                magicBrand!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(children: [
                          Expanded(
                              child: Wrap(
                            spacing: 3.0,
                            runSpacing: 3.0,
                            children: magicBrand!
                                .map(
                                  (e) => Container(
                                    // margin: EdgeInsets.all(3.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        // color: Colors.green,
                                        // color: Color(
                                        //         (math.Random().nextDouble() *
                                        //                 0xFFFFFF)
                                        //             .toInt())
                                        //     .withOpacity(.8),
                                        color: Colors.primaries[Random()
                                                .nextInt(
                                                    Colors.primaries.length)]
                                            .withOpacity(.4),
                                        borderRadius: BorderRadius.circular(5)),

                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Color.fromARGB(255, 50, 49, 49),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ))
                        ]),
                      )
                    : const SizedBox.shrink()
              ],
            )

            // ListTile(
            //   contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            //   minVerticalPadding: 0,
            //   title:
            //       //  AnimatedTextKit(repeatForever: true, animatedTexts: [
            //       //   ColorizeAnimatedText(clientName,
            //       //       textStyle: const TextStyle(
            //       //         fontSize: 16,
            //       //       ),
            //       //       colors: [
            //       //         const Color(0xff027DFD),
            //       //         const Color(0xff4100E0),
            //       //         const Color(0xff1CDAC5),
            //       //         const Color(0xffF2DD22)
            //       //       ]),
            //       // ]),

            //       Text(
            //     clientName,
            //     style:
            //         const TextStyle(color: Color.fromARGB(255, 0, 174, 29)
            //             // color: Color(0xff4100E0),
            //             // color: const Color.fromARGB(255, 138, 201, 149),
            //             // color: Color.fromARGB(255, 30, 66, 77),
            //             // fontSize: 18,
            //             // fontWeight: FontWeight.w600,
            //             ),
            //   ),
            //   subtitle: magicBrand!.isNotEmpty
            //       ? SizedBox(
            //           height: 100,
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 '$base, $marketName',
            //                 style: const TextStyle(
            //                     color: Color.fromARGB(255, 86, 173, 100)
            //                     // color: Color.fromARGB(255, 150, 121, 224),
            //                     // color: Color.fromARGB(255, 30, 66, 77),
            //                     ),
            //               ),
            //               magicBrand!.isNotEmpty
            //                   ? Row(children: [
            //                       Expanded(
            //                           child: Wrap(
            //                         spacing: 3.0,
            //                         runSpacing: 3.0,
            //                         children: magicBrand!
            //                             .map(
            //                               (e) => Container(
            //                                 // margin: EdgeInsets.all(3.0),
            //                                 padding: EdgeInsets.all(3.0),
            //                                 color: Colors
            //                                     .blue, // Customize container color
            //                                 child: Text(e),
            //                               ),
            //                             )
            //                             .toList(),
            //                       ))
            //                     ])
            //                   : SizedBox.shrink()
            //             ],
            //           ),
            //         )
            //       : Text(
            //           '$base, $marketName',
            //           style: const TextStyle(
            //               color: Color.fromARGB(255, 86, 173, 100)
            //               // color: Color.fromARGB(255, 150, 121, 224),
            //               // color: Color.fromARGB(255, 30, 66, 77),
            //               ),
            //         ),
            //   trailing: boolIcon
            //       ? SizedBox(
            //           // height: 60,
            //           width: 110,
            //           child: Row(
            //             children: [
            //               Padding(
            //                 padding:
            //                     const EdgeInsets.only(right: 10, left: 10),
            //                 child: SizedBox(
            //                     height: 30,
            //                     child: Image.asset(
            //                       'assets/images/m.png',
            //                       //color: Colors.deepOrange,
            //                     )),
            //               ),
            //               // Transform(
            //               //   alignment: Alignment.center,
            //               //   transform:
            //               //       Matrix4.rotationZ(3.1415926535897932 / 4),
            //               //   child: SizedBox(
            //               //       height: 40,
            //               //       child: Image.asset(
            //               //         'assets/images/m.png',
            //               //         //color: Colors.deepOrange,
            //               //       )),
            //               // ),

            //               IconButton(onPressed: onPressed, icon: icon),
            //             ],
            //           ),
            //         )
            //       : null,
            // ),

            )
        : Card(
            // elevation: 2,
            // color: Colors.yellow.shade50,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              minVerticalPadding: 0,
              title: Text(
                clientName,
                // style: TextStyle(
                //   color: magic == true
                //       ? const Color.fromARGB(255, 138, 201, 149)
                //       : null,
                //   // color: Color.fromARGB(255, 30, 66, 77),
                //   // fontSize: 18,
                //   // fontWeight: FontWeight.w600,
                // ),
              ),
              subtitle: Text(
                '$base, $marketName',
                // style: const TextStyle(
                //     color: Color.fromARGB(255, 30, 66, 77), fontSize: 16),
              ),
              trailing: boolIcon
                  ? IconButton(onPressed: onPressed, icon: icon)
                  : null,
            ),
          );
  }
}

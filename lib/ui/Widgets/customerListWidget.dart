import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
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
            child: Stack(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  minVerticalPadding: 0,
                  title:
                      //  AnimatedTextKit(repeatForever: true, animatedTexts: [
                      //   ColorizeAnimatedText(clientName,
                      //       textStyle: const TextStyle(
                      //         fontSize: 16,
                      //       ),
                      //       colors: [
                      //         const Color(0xff027DFD),
                      //         const Color(0xff4100E0),
                      //         const Color(0xff1CDAC5),
                      //         const Color(0xffF2DD22)
                      //       ]),
                      // ]),

                      Text(
                    clientName,
                    style:
                        const TextStyle(color: Color.fromARGB(255, 0, 174, 29)
                            // color: Color(0xff4100E0),
                            // color: const Color.fromARGB(255, 138, 201, 149),
                            // color: Color.fromARGB(255, 30, 66, 77),
                            // fontSize: 18,
                            // fontWeight: FontWeight.w600,
                            ),
                  ),
                  subtitle: Text(
                    '$base, $marketName',
                    style:
                        const TextStyle(color: Color.fromARGB(255, 86, 173, 100)
                            // color: Color.fromARGB(255, 150, 121, 224),
                            // color: Color.fromARGB(255, 30, 66, 77),
                            ),
                  ),
                  trailing: boolIcon
                      ? SizedBox(
                          // height: 60,
                          width: 110,
                          child: Row(
                            children: [
                               Padding(
                                 padding: const EdgeInsets.only(right: 10,left: 10),
                                 child: SizedBox(
                                      height: 30,
                                      child: Image.asset(
                                        'assets/images/m.png',
                                        //color: Colors.deepOrange,
                                      )),
                               ),
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
                          

                              IconButton(onPressed: onPressed, icon: icon),
                            ],
                          ),
                        )
                      : null,
                ),

                //  Align(
                //   alignment: Alignment.topCenter,
                //   child: ConfettiWidget(
                //     confettiController: confettiController!,
                //     blastDirection: -pi / 2,
                //     emissionFrequency: 0.02,
                //     numberOfParticles: 15,
                //     blastDirectionality: BlastDirectionality.directional,
                //     shouldLoop: true,
                //   ),
                // )
              ],
            ),
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

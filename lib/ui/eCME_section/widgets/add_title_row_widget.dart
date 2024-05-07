import 'package:flutter/material.dart';

class AddTitleRowWidget extends StatelessWidget {
  final BuildContext context ;
  final String title;

  const AddTitleRowWidget({
     super.key,
     required this.context,
     required this.title,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style:const TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.w600),
    
      ),
    );
  }
}
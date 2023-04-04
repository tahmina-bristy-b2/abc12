import 'package:flutter/material.dart';

class CustomerListCardWidget extends StatelessWidget {
  final String clientName;
  final bool boolIcon;
  final Icon icon;
  final VoidCallback onPressed;
  final String base;
  final String marketName;
  final String outstanding;
  const CustomerListCardWidget({
    Key? key,
    required this.clientName,
    required this.boolIcon,
    required this.icon,
    required this.onPressed,
    required this.base,
    required this.marketName,
    required this.outstanding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 2,
      color: Colors.yellow.shade50,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        minVerticalPadding: 0,
        title: Text(
          clientName,
          style: const TextStyle(
              color: Color.fromARGB(255, 30, 66, 77),
              fontSize: 19,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '$base ,$marketName',
          style: const TextStyle(
              color: Color.fromARGB(255, 30, 66, 77), fontSize: 16),
        ),
        trailing:
            boolIcon ? IconButton(onPressed: onPressed, icon: icon) : null,
      ),
    );
  }
}

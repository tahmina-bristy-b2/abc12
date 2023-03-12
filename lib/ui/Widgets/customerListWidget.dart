import 'package:flutter/material.dart';

class CustomerListCardWidget extends StatelessWidget {
  String clientName;

  String base;
  String marketName;
  String outstanding;
  CustomerListCardWidget({
    Key? key,
    required this.clientName,
    required this.base,
    required this.marketName,
    required this.outstanding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  clientName,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 30, 66, 77),
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          child: Text(
                            base + ' ' + ',' + '' + marketName,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 30, 66, 77),
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

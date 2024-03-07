import 'package:flutter/cupertino.dart';

class BatchItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children:const [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text("Batch Id", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text("Expired Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
          ),
        ),
      ],
    );
  }
}
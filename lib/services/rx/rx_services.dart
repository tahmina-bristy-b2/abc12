class RxServices {
  String itemString = "";

  String calculateRxItemString(finalMedicineList) {
    if (finalMedicineList.isNotEmpty) {
      finalMedicineList.forEach((element) {
        if (itemString == '') {
          itemString = '${element.itemId}|${element.quantity}';
        } else {
          itemString += '||${element.itemId}|${element.quantity}';
        }
      });
    }

    return itemString;
  }
}
    // var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    // String time = dt.replaceAll(":", '');
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/models/expired_dated/expired_submit_and_save_data_model.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/cancel-button.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/confirm_widget.dart';
import 'package:MREPORTING/ui/Expired_dated_section/show_dialog/each_batch_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpiredIteminputShowDialogScreen extends StatefulWidget {
  ExpiredItemList expiredItem;
  String itemId;
  String clinetId;
  ExpiredItemSubmitModel? expiredItemSubmitModel;
  Function(ExpiredItemSubmitModel?) callbackFunction;

  ExpiredIteminputShowDialogScreen({
    super.key,
    required this.expiredItem,
    required this.itemId,
    required this.clinetId,
    required this.expiredItemSubmitModel,
    required this.callbackFunction,
  });

  @override
  State<ExpiredIteminputShowDialogScreen> createState() =>
      _ExpiredIteminputShowDialogScreenState();
}

class _ExpiredIteminputShowDialogScreenState
    extends State<ExpiredIteminputShowDialogScreen> {
  DateTime selectedExpiredDate = DateTime.now();
  TextEditingController pcsController = TextEditingController();
  final customerExpiredItemsBox = Boxes.getExpiredItemSubmitItems();
  String selectedExpiredDateString =
      DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<BatchWiseItemListModel> batchWiseItemSaved = [];
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    selectedExpiredDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (widget.expiredItemSubmitModel != null) {
      for (var element in widget.expiredItemSubmitModel!.batchWiseItem) {
        batchWiseItemSaved.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(5),
        contentPadding: EdgeInsets.zero,
        content: StatefulBuilder(
          builder: (context, setState2) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 8,
                          child: Center(
                              child: Text(
                            widget.expiredItem.itemName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ))),
                      Expanded(
                          child: Center(
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EachBtachItemWidget(
                                          itemName: widget.expiredItem.itemName,
                                          batchWiseItemSaved: null,
                                          callbackFunction:
                                              (BatchWiseItemListModel? value) {
                                            if (value == null) {
                                              return;
                                            }
                                            batchWiseItemSaved.add(value);
                                            setState(() {});
                                          },
                                          routeName: false,
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color.fromARGB(255, 82, 179, 98),
                                  ))))
                    ],
                  ),
                  fixedRowWidget(),
                  SizedBox(
                    height: batchWiseItemSaved.length * 50,
                    width: double.maxFinite,
                    child: ListView.builder(
                        itemCount: batchWiseItemSaved.length,
                        itemBuilder: (ctx, index) {
                          final eachSavedBatchItem = batchWiseItemSaved[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EachBtachItemWidget(
                                    itemName: widget.expiredItem.itemName,
                                    batchWiseItemSaved:
                                        batchWiseItemSaved[index],
                                    callbackFunction:
                                        (BatchWiseItemListModel? value) {
                                      batchWiseItemSaved[index] = value!;
                                      setState(() {});
                                    },
                                    routeName: true,
                                  );
                                },
                              );
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 1,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                                child: Text(
                                              eachSavedBatchItem.batchId,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            )),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                                child: Text(
                                              eachSavedBatchItem.expiredDate,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            )),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Center(
                                                  child: Text(
                                                eachSavedBatchItem.unitQty,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              )),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Center(
                                                child: IconButton(
                                                  onPressed: () {
                                                    batchWiseItemSaved
                                                        .removeAt(index);
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.redAccent,
                                                      size: 15),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    (batchWiseItemSaved.length - 1 == index)
                                        ? const SizedBox()
                                        : const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11),
                                            child: Divider(
                                              thickness: 0.7,
                                            ),
                                          )
                                  ],
                                )),
                          );
                        }),
                  )
                ],
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: CancelButtonWidget(
                        buttonHeight: 50,
                        fontColor: const Color.fromARGB(255, 82, 179, 98),
                        buttonName: "Cancel",
                        fontSize: 16,
                        onTapFuction: () {
                          Navigator.pop(context);
                        },
                        borderColor: const Color.fromARGB(255, 82, 179, 98))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: ConfirmButtonWidget(
                  buttonHeight: 50,
                  fontColor: Colors.white,
                  buttonName: "OK",
                  fontSize: 16,
                  onTapFuction: () {
                    final eachItemtemList = ExpiredItemSubmitModel(
                        itemName: widget.expiredItem.itemName.toString(),
                        quantity: widget.expiredItem.stock.toString(),
                        tp: widget.expiredItem.tp.toString(),
                        itemId: widget.expiredItem.itemId.toString(),
                        categoryId: widget.expiredItem.categoryId.toString(),
                        vat: widget.expiredItem.vat.toString(),
                        manufacturer:
                            widget.expiredItem.manufacturer.toString(),
                        itemString: "",
                        batchWiseItem: batchWiseItemSaved);

                    widget.callbackFunction(eachItemtemList);
                    Navigator.pop(context);
                  },
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container fixedRowWidget() {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 138, 201, 149).withOpacity(.3),
              spreadRadius: 2,
              blurStyle: BlurStyle.outer,
              blurRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 138, 201, 149).withOpacity(.3),
        ),
        child: Row(
          children: const [
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Batch Id",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  )),
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Expired Date",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  )),
                )),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Qty",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  )),
                )),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Action",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              )),
            )),
          ],
        ));
  }

  initialValue(String val) {
    return TextEditingController(text: val);
  }

  pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedExpiredDate,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
            ),
            canvasColor: Colors.teal,
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;

    selectedExpiredDate = newDate;
    selectedExpiredDateString =
        DateFormat('yyyy-MM-dd').format(selectedExpiredDate);
    setState(() => selectedExpiredDate = newDate);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

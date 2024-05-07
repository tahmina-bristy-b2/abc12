import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatelessWidget {
 final BuildContext context;
 final String dropdownHint;
 final List<String> dropdownList;
 final TextEditingController dropdownController;
 final void Function(String?)? dropdownOnchanged;
 final String? selectedValue;
 final String textformFiledHint;
 final void Function(bool)? onMenuStateChangeforClear;

  const CustomDropdownWidget({
      super.key,
      required this.context,
      required this.dropdownHint,
      required this.dropdownList,
      required this.dropdownController,
      required this.dropdownOnchanged,
      required this.selectedValue,
      required this.textformFiledHint,
      required this.onMenuStateChangeforClear
    });

  @override
  Widget build(BuildContext context) {
    return  Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 45,
                decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 230, 244, 243),
                ),
                child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                      isExpanded: true,
                                       iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                                       hint:  Text(
                                         dropdownHint,
                                         style:const TextStyle(
                                           fontSize: 14,
                                            ),
                                        ),
                                     items:dropdownList.map((String item) {
                                       return DropdownMenuItem(
                                                    value: item, 
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8),
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                      }).toList(),
                                        value: selectedValue,
                                        onChanged: dropdownOnchanged ,
                                        buttonHeight: 50,
                                        buttonWidth: MediaQuery.of(context).size.width / 1.5,
                                        itemHeight: 40,
                                        dropdownMaxHeight: 252,
                                        searchController: dropdownController,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                                height: 50,
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 4,
                                                  right: 8,
                                                  left: 8,
                                                ),
                                                child: TextFormField(
                                                  expands: true,
                                                  maxLines: null,
                                                  controller: dropdownController,
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.transparent,
                                                    filled: true,
                                                    isDense: true,
                                                    contentPadding: const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 8,
                                                    ),
                                                    hintText: textformFiledHint,
                                                    hintStyle: const TextStyle(fontSize: 14),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              searchMatchFn: (item, searchValue) {
                                                return (item.value.toString().toUpperCase().startsWith(searchValue.toUpperCase()));
                                              },
                                      onMenuStateChange: onMenuStateChangeforClear
                                              
                                    ),
                               )
               );
  
  }
}
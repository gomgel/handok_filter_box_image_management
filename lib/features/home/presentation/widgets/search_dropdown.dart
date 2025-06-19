import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/search_model.dart';

class SearchDropDown extends StatefulWidget {
  final String label;
  final DropdownSearchOnFind<SearchModel>? items;
  final Function(SearchModel) onSelectedItem;

  const SearchDropDown({
    super.key,
    this.label = "",
    required this.items,
    required this.onSelectedItem,
  });

  @override
  State<SearchDropDown> createState() => _SearchEmployeeState();
}

class _SearchEmployeeState extends State<SearchDropDown> {
  SearchModel _selectedItem = SearchModel.withEmpty();

  SearchModel get selectedItem => _selectedItem;
  set selectedItem(SearchModel model) {
    _selectedItem = model;
    widget.onSelectedItem(model);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<SearchModel>(
      selectedItem: _selectedItem,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          label: Text(
            widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
          border: const OutlineInputBorder(),
          prefixIcon: _selectedItem.isEmpty()
              ? null
              : GestureDetector(
                  child: const Icon(Icons.cancel),
                  onTap: () {
                    setState(
                      () {
                        selectedItem = SearchModel.withEmpty();
                      },
                    );
                  },
                ),
        ),
      ),
      itemAsString: (model) => model.name,
      items: widget.items,
      onChanged: (model) {
        setState(() {
          selectedItem = model ?? SearchModel.withEmpty();
        });
      },
      filterFn: (model, str) => true,
      compareFn: (i, s) => i.isEqual(s),
      popupProps: PopupProps<SearchModel>.bottomSheet(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CLOSE")),
        ),
        searchFieldProps: const TextFieldProps(style: TextStyle(color: Colors.black87)),
        searchDelay: const Duration(seconds: 10),
        bottomSheetProps:
            BottomSheetProps(backgroundColor: Colors.blueGrey[50], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))),
        showSearchBox: true,
        itemBuilder: (context, item, isDisabled, isSelected) {
          return ListTile(
            title: Text(
              item.name,
              style: const TextStyle(color: Colors.black87),
            ),
          );
        },
      ),
    );
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/search_model.dart';

class SearchMultiDropDown extends StatefulWidget {
  final String label;
  final int maxSelectableCount;
  final DropdownSearchOnFind<SearchModel>? items;
  final Function(List<SearchModel>) onSelectedItem;

  const SearchMultiDropDown({
    super.key,
    this.label = "",
    this.maxSelectableCount = 3,
    required this.items,
    required this.onSelectedItem,
  });

  @override
  State<SearchMultiDropDown> createState() => _SearchMultiDropDownState();
}

class _SearchMultiDropDownState extends State<SearchMultiDropDown> {
  List<SearchModel> _selectedItems = [];

  List<SearchModel> get selectedItems => _selectedItems;

  set selectedItems(List<SearchModel> models) {
    _selectedItems = models;
    widget.onSelectedItem(models);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<SearchModel>.multiSelection(
      selectedItems: _selectedItems,
      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          border: OutlineInputBorder(),
        ),
      ),
      itemAsString: (model) => model.name,
      items: widget.items,
      onChanged: (models) {
        setState(() {
          selectedItems = models;
        });
      },
      onSaved: (models) {
        debugPrint("saved....");
      },
      filterFn: (model, str) => true,
      compareFn: (i, s) => i.isEqual(s),
      popupProps: PopupPropsMultiSelection<SearchModel>.bottomSheet(
        // showSelectedItems: true,
        onItemAdded: (models, model) {
          setState(
                () {
              if (models.length >= widget.maxSelectableCount + 1) {
                models.removeWhere((item) => item.code == model.code);
                selectedItems = models;
                Navigator.of(context).pop();
              }
              if (models.length == widget.maxSelectableCount) {
                selectedItems = models;
                Navigator.of(context).pop();
              }
            },
          );
        },
        // onItemRemoved: (models, model) {
        //   setState(() {
        //     selectedItems = models;
        //   });
        // },
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
        searchDelay: const Duration(microseconds: 1500),
        bottomSheetProps: BottomSheetProps(
          backgroundColor: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
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

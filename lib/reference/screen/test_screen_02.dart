import 'package:dropdown_search/dropdown_search.dart';
import 'package:filter_box_image_management/core/models/employee_model.dart';
import 'package:filter_box_image_management/features/home/data/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/common_if_model.dart';
import '../../core/models/search_model.dart';
import '../../core/providers/common_provider.dart';
import '../../core/widgets/dialogs.dart';
import '../../features/home/presentation/widgets/search_dropdown.dart';

class TestScreen02 extends ConsumerStatefulWidget {
  const TestScreen02({super.key});

  @override
  ConsumerState<TestScreen02> createState() => _TestScreen02State();
}

class _TestScreen02State extends ConsumerState<TestScreen02> {
  @override
  Widget build(BuildContext context) {
    debugPrint("TestScreen02 build..");

    // final employee = ref.watch(employeeProvider);
    //
    // if (employee is CommonIfModelEmpty) {
    //   debugPrint("employee is CommonIfModelEmpty");
    // } else if (employee is CommonIfModelLoading) {
    //   debugPrint("employee is CommonIfModelLoading");
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // } else if (employee is CommonIfModelError) {
    //   debugPrint("employee is CommonIfModelError - ${(employee as CommonIfModelError).message}");
    // } else {
    //   debugPrint("employee is good!");
    //
    //   for (var item in (employee as CommonIFModel<EmployeeInfo, Null>).item.return_data) {
    //     debugPrint("${item.emp_cd} ${item.emp_nm}");
    //   }
    //
    //   //debugPrint((employee as CommonIFModel<EmployeeInfo, Null>).item.return_data.toString());
    // }

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          ref.read(employeeProvider.notifier).get(name_1st: "ㄱ", name_2nd: "ㅎ", name_3rd: "ㅅ");
                        },
                        child: Text('test')),
                  ],
                ),
                Column(
                  children: [
                    SearchDropDownTest(
                      items: (String filter, LoadProps? loadProps) async {
                        //debugPrint("filter : $filter,  str : $s");

                        // String name = filter.isEmpty ? "ㄱㅈ" : filter;
                        //
                        // final list = await ref.read(employeeProvider.notifier).getForSearching(
                        //       name_1st: name.length > 0 ? name[0] : "",
                        //       name_2nd: name.length > 1 ? name[1] : "",
                        //       name_3rd: name.length > 2 ? name[2] : "",
                        //     );

                        return [
                          SearchModel(code: '12345', name: "1라인"),
                          SearchModel(code: '22222', name: "2라인"),
                          SearchModel(code: '33333', name: "3라인"),
                          SearchModel(code: '44444', name: "4라인"),
                          SearchModel(code: '55555', name: "5라인"),
                        ];
                      },
                      onSelectedItem: (models) {
                        for (var item in models) {
                          debugPrint(item.toString());
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          },
          itemCount: 1,
        ),
      ),
    );
  }
}

class SearchDropDownTest extends StatefulWidget {
  final int maxSelectableCount;
  final DropdownSearchOnFind<SearchModel>? items;
  final Function(List<SearchModel>) onSelectedItem;

  const SearchDropDownTest({
    super.key,
    this.maxSelectableCount = 3,
    required this.items,
    required this.onSelectedItem,
  });

  @override
  State<SearchDropDownTest> createState() => _SearchEmployeeState();
}

class _SearchEmployeeState extends State<SearchDropDownTest> {
  List<SearchModel> _selectedItems = [];

  List<SearchModel> get selectedItems => _selectedItems;

  set selectedItems(List<SearchModel> models) {
    _selectedItems = models;
    widget.onSelectedItem(models);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownSearch<SearchModel>.multiSelection(
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
          debugPrint("onChanged..");
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
      ),
    );
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:filter_box_image_management/core/models/employee_model.dart';
import 'package:filter_box_image_management/features/home/data/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/common_if_model.dart';
import '../../core/providers/common_provider.dart';
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
                    SearchDropDown(items: (String filter, LoadProps? loadProps) async {
                        //debugPrint("filter : $filter,  str : $s");

                        String name = filter.isEmpty ? "ㄱㅈ" : filter;

                        final list = await ref.read(employeeProvider.notifier).getForSearching(
                              name_1st: name.length > 0 ? name[0] : "",
                              name_2nd: name.length > 1 ? name[1] : "",
                              name_3rd: name.length > 2 ? name[2] : "",
                            );

                        return list;
                    }, onSelectedItem: (emp){
                      debugPrint("Selected Changed : ${emp.toString()}" );
                    },),
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

// class SearchDropDown extends StatefulWidget {
//
//   final DropdownSearchOnFind<EmployeeModel>? items;
//   final Function(EmployeeModel) onSelectedItem;
//
//   const SearchDropDown({super.key, required this.items, required this.onSelectedItem});
//
//   @override
//   State<SearchDropDown> createState() => _SearchEmployeeState();
// }
//
// class _SearchEmployeeState extends State<SearchDropDown> {
//
//   EmployeeModel _selectedItem = EmployeeModel.withEmpty();
//
//   EmployeeModel get selectedItem => _selectedItem;
//   set selectedItem(EmployeeModel emp){
//     _selectedItem = emp;
//     widget.onSelectedItem(emp);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: DropdownSearch<EmployeeModel>(
//         selectedItem: _selectedItem,
//         decoratorProps: DropDownDecoratorProps(
//           decoration: InputDecoration(
//               contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
//               border: OutlineInputBorder(),
//               prefixIcon: _selectedItem.isEmpty()
//                   ? null
//                   : GestureDetector(
//                       child: Icon(Icons.cancel),
//                       onTap: () {
//                         setState(() {
//                           selectedItem = EmployeeModel.withEmpty();
//                         });
//                       },
//                     )),
//         ),
//         itemAsString: (model) => model.emp_nm,
//         items: widget.items,
//         // items: (filter, s) async {
//         //   debugPrint("filter : $filter,  str : $s");
//         //
//         //   String name = filter.isEmpty ? "ㄱㅈ" : filter;
//         //
//         //   final list = await ref.read(employeeProvider.notifier).getForSearching(
//         //         name_1st: name.length > 0 ? name[0] : "",
//         //         name_2nd: name.length > 1 ? name[1] : "",
//         //         name_3rd: name.length > 2 ? name[2] : "",
//         //       );
//         //
//         //   return list;
//         // },
//         onChanged: (model) {
//           setState(() {
//             selectedItem = model ?? EmployeeModel.withEmpty();
//           });
//         },
//         filterFn: (model, str) => true,
//         compareFn: (i, s) => i.isEqual(s),
//         popupProps: PopupProps<EmployeeModel>.bottomSheet(
//           title: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0.0),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text("CLOSE")),
//           ),
//           searchFieldProps: const TextFieldProps(style: TextStyle(color: Colors.black87)),
//           searchDelay: const Duration(microseconds: 1500),
//           bottomSheetProps:
//               BottomSheetProps(backgroundColor: Colors.blueGrey[50], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))),
//           showSearchBox: true,
//           itemBuilder: (context, item, isDisabled, isSelected) {
//             return ListTile(
//               title: Text(
//                 item.emp_nm,
//                 style: const TextStyle(color: Colors.black87),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

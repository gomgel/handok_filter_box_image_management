import 'package:filter_box_image_management/features/home/data/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/global_provider.dart';

class BaseScreen extends ConsumerWidget {
  Widget body;
  Widget? floatingActionButton;
  String title;

  BaseScreen({super.key, required this.body, this.floatingActionButton, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final user = ref.watch(loginUserProvider);
    final line = ref.watch(loginLineProvider);

    var names = "";
    var lines = "";

    for(var item in user) {
      names = "$names ${item.name}";
    }

    for(var item in line) {
      lines = "$lines ${item.name}";
    }

    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(54.0),
        child: AppBar(
          //backgroundColor: Colors.red,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'HANDOK PDA',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    children: [
                      // Text(
                      //   lines,
                      //   overflow: TextOverflow.fade,
                      //   style: TextStyle(
                      //     color: Theme.of(context).colorScheme.primary,
                      //     fontSize: 12.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //
                      // ),
                      Text(
                        names,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )

                ],
              ),
              Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: body,
    );
  }
}

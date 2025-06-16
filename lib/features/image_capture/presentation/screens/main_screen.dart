import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/base_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: '',
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          SizedBox(
            height: 24.0,
          ),
        ],
      ),
    );
  }
}

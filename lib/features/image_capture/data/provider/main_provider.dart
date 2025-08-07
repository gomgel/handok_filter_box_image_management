

import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowCountProvider = StateProvider<int>((ref) => 0);
final selectedLinesProvider = StateProvider.autoDispose<List<bool>>((ref) => [true, false]);



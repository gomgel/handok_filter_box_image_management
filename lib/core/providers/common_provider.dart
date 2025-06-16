import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/common_repository.dart';
import '../utils/dio.dart';
import 'global_provider.dart';
//
final commonRepositoryProvider = Provider<CommonRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final config = ref.watch(configProvider);
  final repository = CommonRepository(dio, baseUrl: config.host);
  return repository;
});


import 'package:filter_box_image_management/core/models/search_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/config_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum LoadingType { none, loading, completed, error }

final loadingProvider = StateProvider<LoadingType>((ref) => LoadingType.none);

final rootNavigatorKey = Provider<GlobalKey<NavigatorState>>((ref) => GlobalKey());

final activeTime = StateProvider<DateTime>((ref) => DateTime.now());

final sharedPreferenceProvider = Provider((ref) => SharedPreferences.getInstance());

final loginUserProvider = StateProvider<List<SearchModel>>((ref) => []);
final loginLineProvider = StateProvider<List<SearchModel>>((ref) => []);

final versionProvider = FutureProvider((ref) async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  } catch (e) {
    return '9.9.9';
  }
});

final configProvider = StateNotifierProvider<ConfigNotifier, ConfigModel>((ref) {
  return ConfigNotifier(ref);
});

class ConfigNotifier extends StateNotifier<ConfigModel> {
  final StateNotifierProviderRef ref;
  late SharedPreferences pref;

  ConfigNotifier(this.ref)
      : super(ConfigModel(
    line: "B0001",
    lineName: "선압2호기",
    host: "http://10.129.132.119:3000/pda",//"10.152.26.89",
    port: "3000",
    updateHost: "http://10.129.132.119:3000",
    updatePort: "3000",
  )) {
    refresh();
  }

  Future<int> refresh() async {
    final pref = await ref.watch(sharedPreferenceProvider);

    try {

      final emptyDv = pref.getString("host") ?? "";
      if ( ( emptyDv == "" ) ) {
        await pref.setString("line", "B0001");
        await pref.setString("lineName", "선압2호기");
        await pref.setString("host", "http://192.168.0.80:3000/pda");
        await pref.setString("port", "3000");
        await pref.setString("updateHost", "http://192.168.0.80:3000");
        await pref.setString("updatePort", "3000");
      }

      final line = pref.getString("line") ?? "B0001";
      final lineName = pref.getString("lineName") ?? "선압2호기";
      final host = pref.getString("host") ?? "http://192.168.0.80:3000/pda";
      final port = pref.getString("port") ?? "3000";
      final updateHost = pref.getString("updateHost") ?? "http://192.168.0.80:3000";
      final updatePort = pref.getString("updatePort") ?? "3000";

      state = ConfigModel(
        line: line,
        lineName: lineName,
        host: host,
        port: port,
        updateHost: updateHost,
        updatePort: updatePort,
      );

      return 0;
    } catch (e) {
      return -1;
    }
  }

  saveConfig(ConfigModel model) async {
    final pref = await ref.watch(sharedPreferenceProvider);
    try {
      await pref.setString("line", model.line);
      await pref.setString("lineName", model.lineName);
      await pref.setString("host", model.host);
      await pref.setString("port", model.port);
      await pref.setString("updateHost", model.updateHost);
      await pref.setString("updatePort", model.updatePort);
      state = model;
    } catch (e) {}
  }

}

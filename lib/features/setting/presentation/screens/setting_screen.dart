import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/providers/global_provider.dart';
import '../../../../core/utils/utils.dart';

class SettingScreen extends ConsumerStatefulWidget {

  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  var config = ref.watch(configProvider);

    return Column(
      children: [
        Expanded(
          child: SettingsScreen(
            //title: 'Application Settings',
            hasAppBar: false,
            children: [
              SettingsGroup(
                title: 'Application Setting',
                children: <Widget>[
                  ExpandableSettingsTile(
                    title: '서버정보',
                    subtitle: '운영서버, 업데이트서버 정보를 관리 합니다. ',
                    expanded: true,
                    children: <Widget>[
                      TextInputSettingsTile(
                        title: '운영서버정보 - Host',
                        settingKey: 'host',
                        //initialValue: 'admin',
                        validator: (String? value) {
                          debugPrint("validator called...");
                          return null;
                        },
                        onChange: (value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          ref.refresh(configProvider);
                          debugPrint(prefs.get("host").toString());
                        },
                        borderColor: Colors.blueAccent,
                        errorColor: Colors.deepOrangeAccent,
                      ),
                      TextInputSettingsTile(
                        title: '운영서버정보 - Port',
                        settingKey: 'port',
                        validator: (String? value) {
                          debugPrint("validator called...");
                          //ref.refresh(configProvider);
                          return null;
                          //debugPrint();
                        },
                        onChange: (value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          ref.refresh(configProvider);
                          debugPrint(prefs.get("port").toString());
                        },
                        borderColor: Colors.blueAccent,
                        errorColor: Colors.deepOrangeAccent,
                      ),
                      TextInputSettingsTile(
                        title: '업데이트서버정보 - Host',
                        settingKey: 'updateHost',
                        validator: (String? value) {
                          debugPrint("validator called...");
                          return null;
                          //debugPrint();
                        },
                        onChange: (value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          ref.refresh(configProvider);
                          debugPrint(prefs.get("updateHost").toString());
                        },
                        borderColor: Colors.blueAccent,
                        errorColor: Colors.deepOrangeAccent,
                      ),
                      TextInputSettingsTile(
                        title: '업데이트서버정보 - Port',
                        settingKey: 'updatePort',
                        validator: (String? value) {
                          debugPrint("validator called...");
                          //ref.refresh(configProvider);
                          return null;
                          //debugPrint();
                        },
                        onChange: (value) async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          ref.refresh(configProvider);
                          debugPrint(prefs.get("updatePort").toString());
                        },
                        borderColor: Colors.blueAccent,
                        errorColor: Colors.deepOrangeAccent,
                      ),
                    ],
                  ),
                  // CheckboxSettingsTile(
                  //   settingKey: 'isSaveDoc',
                  //   title: '실시간으로 스캔정보를 저장합니다.',
                  //   onChange: (value) async{
                  //     ref.read(configProvider.notifier).refresh();
                  //   },
                  // ),
                  FutureBuilder(
                      future: getVersionInfo(),
                      builder: (context, snapshot) {
                        //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                        if (snapshot.hasData == false) {
                          return const CircularProgressIndicator();
                        }
                        //error가 발생하게 될 경우 반환하게 되는 부분
                        else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          );
                        }
                        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                        else {
                          return SimpleSettingsTile(
                            title: '버정정보',
                            subtitle: snapshot.data!,
                            enabled: false,
                          );
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  doSocketTest(
                    context: context,
                    host: prefs.get("host").toString(),
                    port: int.parse(prefs.get("port").toString()),
                  );
                },
                child: Text('운영테스트'),
              ),
              ElevatedButton(onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                doSocketTest(
                  context: context,
                  host: prefs.get("updateHost").toString(),
                  port: int.parse(prefs.get("updatePort").toString()),
                );
              }, child: Text('업데이트테스트')),
            ],
          ),
        )
      ],
    );
  }

  Future<void> doSocketTest({required BuildContext context, required String host, required int port}) async {
    Socket? socket;

    String received = '';

    try {
      socket = await Socket.connect(host, port, timeout: const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        CommonUtils.instance.alertSnackBar(
          context: context,
          type: SnackBarType.standard,
          message: '연결성공',
        ),
      );

      // _socket!.write(send);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        CommonUtils.instance.alertSnackBar(
          context: context,
          type: SnackBarType.error,
          message: 'Exception ${e.toString()}',
        ),
      );
    }
  }

  Future<String> getVersionInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      return '${packageInfo.version}(${packageInfo.buildNumber})';
    } catch (e) {
      return '';
    }
  }
}

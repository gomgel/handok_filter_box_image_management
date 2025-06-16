import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../providers/global_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(CustomInterceptor(ref: ref));
  return dio;
});

class CustomInterceptor extends Interceptor {
  bool isLogoutState = false;

  ProviderRef ref;

  CustomInterceptor({required ProviderRef this.ref});

  // 1) 요청을 보낼 때 마다 호출 됨. before request
  // Interceptor 가 추가된 Dio 를 쓰는 요청일 경우....
  //     - final dio = Dio();
  //     - dio.interceptors.add(CustomInterceptor());
  // 요청을 보낼 때 마다 hearder 를 검사해서 특정 값을 변경 할 수 있음, 아래는 accessToken 을 변경하는 로직,....
  // 이렇게 하면 매번 요청을 할 떄 마다 accessToken 을 신경을 안써도 됨.... 자동으로 Interceptor 의 OnReqeust 에서 처리 할 거기 때문에....

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('[REQ] [${options.method}] [${options.uri}] ]');

    ref.read(activeTime.notifier).state = DateTime.now();

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('[RSP] [${response.requestOptions.method}] [${response.requestOptions.uri}] ]');

   // debugPrint(response.data.toString());

    super.onResponse(response, handler);
  }

  // 3) 에러가 났을 떄
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    //401 에러가 났을 떄 (status code) 참고로 401 이 Token 에러라는것은 예제로 제공해준 서버에서만 정의 한거임, 다른걸로 정의해도됨.
    //토큰을 재발급을 시도하고 재발급이 완료되면
    //다시 새로운 토큰으로 요청을 한다.........

    debugPrint('[ERR] [${err.requestOptions.method}] [${err.requestOptions.uri}] ]');

    return handler.reject(err);
  }
}

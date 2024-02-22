import 'package:dio/dio.dart';
import 'package:gonggam/ui/common/alert.dart';

class CustomLogInterceptor extends Interceptor {

  List<String> skipErrCode = ["GG3003","GG3004"];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // print('REQUEST[${options.method}] => PATH: ${options.path}');
    if (options.data != null) {
      // print('REQUEST DATA => ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    // print('RESPONSE DATA => $response');

    Map<String,dynamic> jsonData = response.data;
    if(jsonData['code'] != "GG200" && !skipErrCode.contains(jsonData['code'])) {
      Alert.alertDialog(jsonData['code'] + " : " + jsonData['message']);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:gonggam/ui/common/alert.dart';

import 'info_utils.dart';

class SettingService {
  Future<String> _getEmailBody() async {
    Map<String, dynamic> userInfo = getUserInfo();
    Map<String, dynamic> appInfo = await getAppInfo();
    Map<String, dynamic> deviceInfo = await getDeviceInfo();

    String body = "";

    userInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    appInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    deviceInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    body += "--------------\n";

    return body;
  }

  void sendEmail(BuildContext context) async {

    String body = await _getEmailBody();

    final Email email = Email(
      body: body,
      subject: '[공감책방 문의]',
      recipients: ['gonggambook@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      String title = "이메일 앱을 사용할 수 없습니다.\n아래 이메일로 문의 주세요\ngonggambook@gmail.com";
      String message = "";
      Alert.alertDialog(title);
    }
  }
}
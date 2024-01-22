import 'package:gonggam/common/constants.dart';
import 'package:intl/intl.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'main.dart';

class Utils {
  static final _newVersion = NewVersionPlus(iOSAppStoreCountry: "KR", androidPlayStoreCountry: "KR");

  static String formatDate(String format, int daysToAdd) {
    final now = DateTime.now().add(Duration(days: daysToAdd));
    return DateFormat(format).format(now);
  }

  static bool isAfterCreateAt(String createAt, int daysToAdd) {
    DateTime targetDatetime = DateTime.now().add(Duration(days: daysToAdd));
    DateTime targetDate = DateTime(targetDatetime.year, targetDatetime.month, targetDatetime.day);

    return DateTime.parse(createAt).isBefore(targetDate);
  }

  static String getProfileImageUrl(int hashCode) {
    int profileNo = (hashCode % 14) + 1;
    return "$S3_URL/profile$profileNo.png";
  }

  static Future<VersionStatus?> appVersionCheck() async {
    try {
      return await _newVersion.getVersionStatus();
    } catch (err) {
      PackageInfo info = await PackageInfo.fromPlatform();
      return VersionStatus(localVersion: info.version, storeVersion: info.version, appStoreLink: "");
    }
  }
  
  static void showUpdateDialog(VersionStatus? version) {
    _newVersion.showUpdateDialog(
        context: navigatorKey.currentContext!,
        versionStatus: version!,
        dialogTitle: "최신 버젼의 앱이 있습니다.",
        dialogText: "안정적인 사용을 위해 \n업데이트를 진행해주세요.\n최신 : ${version.storeVersion} / 현재 : ${version.localVersion}",
        updateButtonText: "업데이트하기",
        allowDismissal: false);
  }
}
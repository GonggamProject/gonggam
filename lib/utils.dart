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

  static String targetDateToFormatDate(DateTime datetime, String format) {
    return DateFormat(format).format(datetime);
  }

  static DateTime getPreviousMonth(DateTime date) {
    int year = date.month == 1 ? date.year - 1 : date.year;
    int month = date.month == 1 ? 12 : date.month - 1;
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, lastDayOfMonth, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
  }

  static DateTime getNextMonth(DateTime date) {
    int year = date.month == 12 ? date.year + 1 : date.year;
    int month = date.month == 12 ? 1 : date.month + 1;
    return DateTime(year, month, 1, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
  }

  static int compartDateTimeByMonth(DateTime targetA, DateTime targetB) {
    if (targetA.year == targetB.year && targetA.month == targetB.month) {
      return 0;
    } else if(targetA.year >= targetB.year && targetA.month > targetB.month ) {
      return 1;
    } else {
      return -1;
    }
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

  static String dailyPushText(int dailyPushTime) {
    if (dailyPushTime == -1) return "";

    // 0 ~ 11
    if (dailyPushTime < 12) {
      if (dailyPushTime == 0) {
        return "오전 12:00";
      } else {
        return "오전 $dailyPushTime :00";
      }
    } else { // 12 ~ 23
      if (dailyPushTime == 12) {
        return "오후 12:00";
      } else {
        return "오후 ${dailyPushTime - 12} :00";
      }
    }
  }
}
import 'package:gonggam/common/constants.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(String format, int daysToAdd) {
    final now = DateTime.now().add(Duration(days: daysToAdd));
    return DateFormat(format).format(now);
  }

  static String getProfileImageUrl(int hashCode) {
    int profileNo = (hashCode % 14) + 1;
    return "$S3_URL/profile$profileNo.png";
  }
}
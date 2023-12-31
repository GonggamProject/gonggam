import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gonggam/common/prefs.dart';
import 'package:package_info_plus/package_info_plus.dart';

Map<String, dynamic> getUserInfo() {
  Map<String, dynamic> userInfo = <String, dynamic>{};
  userInfo['닉네임'] = Prefs.getCustomerName();
  userInfo['ID'] = Prefs.getCustomerId();
  return userInfo;
}

Future<Map<String, dynamic>> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};

  try {
    if (Platform.isAndroid) {
      deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
  } catch(error) {
    deviceData = {
      "Error": "Failed to get platform version."
    };
  }

  return deviceData;
}

Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
  var release = info.version.release;
  var sdkInt = info.version.sdkInt;
  var manufacturer = info.manufacturer;
  var model = info.model;

  return {
    "OS 버전": "Android $release (SDK $sdkInt)",
    "기기": "$manufacturer $model"
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
  var systemName = info.systemName;
  var version = info.systemVersion;
  var machine = info.utsname.machine;

  return {
    "OS 버전": "$systemName $version",
    "기기": machine
  };
}

Future<Map<String, dynamic>> getAppInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return {
    "공감책방": info.version
  };
}
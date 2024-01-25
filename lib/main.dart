
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:gonggam/ui/bookstore/share_note_widget.dart';
import 'package:gonggam/ui/splash_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'common/notification.dart';
import 'common/prefs.dart';
import 'common/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  await Prefs.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // FlutterLocalNotification.init();
  //
  // Future.delayed(const Duration(seconds: 3),
  //     FlutterLocalNotification.requestNotificationPermission()
  // );
  //
  // FlutterLocalNotification.notificationHandler();

  KakaoSdk.init(
    nativeAppKey: 'aaf1230d1f2f981d6e5e9960076c006e',
  );

  await SentryFlutter.init(
        (options) => options.dsn = 'https://6291044e98b57f2507692a272fa32826@o4506444991758336.ingest.sentry.io/4506444992806912',
    appRunner: () => runApp(GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        ),
        supportedLocales: const [
          Locale('ko', ''),
        ],
        theme: ThemeData(
          checkboxTheme: const CheckboxThemeData(splashRadius: 0),
          primarySwatch: Colors.blue,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: const SplashWidget(),
        // home: const ShareNoteWidget(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        navigatorKey: navigatorKey,
      ),
    )),
  );
}
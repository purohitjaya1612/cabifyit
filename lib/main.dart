import 'dart:io';
import 'package:cabifyit/reusability/theme/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
      // name: Platform.isIOS?"Cabifyit":null,
      // options: FirebaseOptions(
      //     apiKey: "AIzaSyCe-nr1KAz5rFtGM9ulCF7dBWFzqHr1lqc",
      //     appId: Platform.isIOS?"1:202615900430:ios:f8cb8916150cab69be2f5f":"1:389652071222:android:1c4c9ba93e33a4565e2997",
      //     messagingSenderId: "202615900430",
      //     projectId: "cabifyit")
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cabifyit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appPrimaryColor),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.white100,
          appBarTheme: AppBarTheme(
              backgroundColor: AppColors.white100
          )
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}


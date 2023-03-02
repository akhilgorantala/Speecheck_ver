import 'package:appspector/appspector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_voice_test/screens/SplashScreen.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  runAppSpector();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await Hive.openBox('data');
  runApp(MyApp());
}

void runAppSpector() {
  final config = Config()
    ..iosApiKey = "Your iOS API_KEY"
    ..androidApiKey =
        "android_NjQwNWM5ZmQtN2NkNC00OWMxLTg4OGYtZTRhNmU4NjQzN2Zk";

  // If you don't want to start all monitors you can specify a list of necessary ones
  config.monitors = [Monitors.http, Monitors.logs, Monitors.screenshot];

  AppSpectorPlugin.run(config);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'Speecheck',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

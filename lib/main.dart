import 'package:drawing/models/offset_custom.dart';
import 'package:drawing/models/stroke.dart';
import 'package:drawing/screens/drawing_screen.dart';
import 'package:drawing/screens/home_screen.dart';
import 'package:drawing/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(OffsetCustomAdapter());
  Hive.registerAdapter(StrokeAdapter());

  await Hive.openBox<List<Stroke>>("drawings");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/home": (context) => const HomeScreen(),
        "/drawing": (context) => const DrawingScreen(),
      },
    );
  }
}

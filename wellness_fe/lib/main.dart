import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellness_fe/di.dart';
import 'package:wellness_fe/resources/app_colours.dart';
import 'package:wellness_fe/resources/styles.dart';
import 'package:wellness_fe/vistitors/visitors_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const url = "https://oxcpprcaaiglrnaeyjtf.supabase.co/";
  const key =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94Y3BwcmNhYWlnbHJuYWV5anRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU2MDc5MjYsImV4cCI6MjA0MTE4MzkyNn0.f8X2ioYENQAmtr-KNZ4Z9eRS6GiwH1HOhoO5ZxvDVGs";

  await Supabase.initialize(
    url: url,
    anonKey: key,
  );

  initDI();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness Bruntál',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlueColor,
          title: Text('Wellness Bruntál',
              style: Styles.headerStyle().withColor(Colors.white)),
        ),
        body: Container(
          color: AppColors.darkBlueColor,
          child: Center(
            child: VisitorsWidget(),
          ),
        ),
      ),
    );
  }
}

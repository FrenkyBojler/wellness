import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellness_fe/di.dart';
import 'package:wellness_fe/resources/app_colours.dart';
import 'package:wellness_fe/resources/styles.dart';
import 'package:wellness_fe/vistitors/visitors_widget.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    print('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env file');
  } else {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

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

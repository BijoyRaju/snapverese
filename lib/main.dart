import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/auth_controller.dart';
import 'package:snapverese/controller/post_controller.dart';
import 'package:snapverese/controller/user_controller.dart';
import 'package:snapverese/view/splash_screen/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0c2xzZHl1d2Nnbmpxam1jaWp5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE0NjIxMjEsImV4cCI6MjA2NzAzODEyMX0.IekOZPtluyppnnDQJFMN2Xb8tSMzXNpISrRf0Nc5GHw',
    url: 'https://etslsdyuwcgnjqjmcijy.supabase.co'
    );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PostController()),
        ChangeNotifierProvider(create: (_) => UserController())
      ],
      child: MaterialApp(
        title: "SNAPvERESE",
        home: SplashScreen(),
      ),
    );
  }
}

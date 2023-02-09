import 'package:chat_project/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/chat_provider.dart';
import 'views/sign_up_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Advanced Chat',
        theme: ThemeData(
            primarySwatch: Colors.teal,
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                color: Colors.black,
              ),
              titleLarge: TextStyle(
                color: Colors.white,
              ),
              bodyLarge: TextStyle(color: Colors.white, fontSize: 20),
              titleMedium: TextStyle(
                color: Colors.white,
              ),
            )),
        home: const SignUpScreen(),
      ),
    );
  }
}

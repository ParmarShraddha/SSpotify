import 'package:flutter/material.dart';
import 'package:spotify_client/core/theme/theme.dart';

import 'features/auth/view/pages/signup_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: const SignupPage(),
    );
  }
}

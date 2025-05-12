import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'start.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://tboamzlydluhubncnoqw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRib2Ftemx5ZGx1aHVibmNub3F3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MjQ3MzMsImV4cCI6MjA2MDIwMDczM30.O5vITu3VZjwI8oZzR7dsiEa7Hr_g2csbRUy8FN23Djk',
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: Start(),
    );
  }
}

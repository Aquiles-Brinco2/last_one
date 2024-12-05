// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/api_bloc.dart';
import 'screens/screen_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon CRUD',
      debugShowCheckedModeBanner:
          false, // Aquí se desactiva la etiqueta "debug"
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => ApiBlocBloc(),
        child: ApiScreen(),
      ),
    );
  }
}

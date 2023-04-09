import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/task_provider.dart';
import '/screens/home_screen.dart';
import '/screens/task_form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => HomeScreen(),
          TaskFormScreen.routeName: (_) => TaskFormScreen(),
        },
      ),
    );
  }
}

import 'package:crud_app_assignment/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CrudApp());
}

class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xffFF9800),
                foregroundColor: Colors.white,
                centerTitle: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
                shadowColor: Colors.black,
                elevation: 5),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xffFF9800),
              foregroundColor: Colors.white,
              shape: CircleBorder(),
            ),
            listTileTheme: const ListTileThemeData(
                iconColor: Colors.orange,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                titleTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFF9800),
                ),
                subtitleTextStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 2,
                )),
            inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red))),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 13),

            )
          )
        ));
  }
}

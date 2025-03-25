import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vecindapp/providers/residential_provider.dart';
import 'package:vecindapp/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResidentialProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}

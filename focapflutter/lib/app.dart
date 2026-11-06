import 'package:flutter/material.dart';

class FocapApp extends StatelessWidget {
  const FocapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Focap',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Focap'))),
    );
  }
}
